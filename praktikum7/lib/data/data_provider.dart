import 'package:flutter/material.dart';
import 'package:mydj/data/database_helper.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:mydj/data/login_info.dart';

class DataProvider extends ChangeNotifier {
  List<Jurnal> _jurnalTersimpan = [];

  // ------------------- Sesi pengguna (Shared Preferences) -------------------

  // Cek sudah login atau belum.
  Future<bool> isLoggedIn() async {
    final LoginInfo loginInfo = await LoginInfo.fromSharedPreferences();
    return loginInfo.isLoggedIn;
  }

  // Simpan informasi sesi ketika login.
  Future<void> saveLoginInfo(String username, String password) async {
    final LoginInfo loginInfo = await LoginInfo.fromSharedPreferences();
    // Isi
    loginInfo.username = username;
    loginInfo.password = password;
    loginInfo.isLoggedIn = true;
    // Simpan
    await loginInfo.saveToSharedPreferences();
  }

  // ------------------- Jurnal (SQLite) -------------------

  // READ: ambil semua jurnal dari database.
  Future<void> muatJurnal() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final rows = await db.query('jurnal', orderBy: 'id DESC');
      _jurnalTersimpan = rows.map((row) => Jurnal.fromMap(row)).toList();
    } catch (error) {
      // Database belum siap (mis. pada pengujian di host).
      _jurnalTersimpan = [];
    }
    notifyListeners();
  }

  // CREATE: simpan jurnal baru, lalu muat ulang daftarnya.
  Future<void> tambahJurnal(Jurnal jurnal) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('jurnal', jurnal.toMap());
    await muatJurnal();
  }

  // UPDATE: perbarui jurnal yang sudah ada, lalu muat ulang daftarnya.
  Future<void> ubahJurnal(Jurnal jurnal) async {
    final db = await DatabaseHelper.instance.database;
    // Kolom id tidak ikut di-update, id tetap menjadi penanda baris.
    final Map<String, dynamic> data = jurnal.toMap()..remove('id');
    await db.update(
      'jurnal',
      data,
      where: 'id = ?',
      whereArgs: [jurnal.id],
    );
    await muatJurnal();
  }

  // DELETE: hapus jurnal berdasarkan id, lalu muat ulang daftarnya.
  Future<void> hapusJurnal(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('jurnal', where: 'id = ?', whereArgs: [id]);
    await muatJurnal();
  }

  List<Jurnal> get jurnalTersimpan {
    return List.unmodifiable(_jurnalTersimpan);
  }
}
