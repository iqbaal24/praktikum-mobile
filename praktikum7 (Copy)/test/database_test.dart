// Uji CRUD jurnal di SQLite (menjalankan database lewat sqflite_common_ffi
// agar bisa diuji pada host, bukan hanya di perangkat Android).
import 'package:flutter_test/flutter_test.dart';
import 'package:mydj/data/database_helper.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('CREATE, READ, UPDATE, DELETE berjalan benar', () async {
    final db = await DatabaseHelper.instance.database;

    // CREATE
    await db.insert(
      'jurnal',
      Jurnal(
        kelas: '3A',
        mapel: 'Matematika',
        jam: 2,
        tujuanPembelajaran: 'Menjumlah',
      ).toMap(),
    );

    // READ
    var rows = await db.query('jurnal');
    expect(rows.length, 1);
    expect(rows.first['kelas'], '3A');
    expect(rows.first['mapel'], 'Matematika');
    expect(rows.first['jam'], 2);

    // UPDATE (bukan insert baru)
    await db.update(
      'jurnal',
      Jurnal(
        kelas: '3B',
        mapel: 'Matematika',
        jam: 2,
        tujuanPembelajaran: 'Menjumlah',
      ).toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [rows.first['id']],
    );

    rows = await db.query('jurnal');
    expect(rows.length, 1, reason: 'UPDATE tidak boleh menambah baris baru');
    expect(rows.first['kelas'], '3B');

    // DELETE
    await db.delete('jurnal', where: 'id = ?', whereArgs: [rows.first['id']]);
    rows = await db.query('jurnal');
    expect(rows.isEmpty, isTrue);
  });
}
