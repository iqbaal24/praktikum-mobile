import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton: hanya ada satu objek DatabaseHelper di seluruh aplikasi.
  static final DatabaseHelper instance = DatabaseHelper._();
  DatabaseHelper._();

  Database? _db;

  // Database dibuka hanya jika belum pernah dibuka.
  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    // Lokasi folder database di perangkat + nama file database.
    final path = join(await getDatabasesPath(), 'mydj.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Dijalankan sekali saja, yaitu ketika file database pertama kali dibuat.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE jurnal ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'kelas TEXT, '
      'mapel TEXT, '
      'jam INTEGER, '
      'tujuanPembelajaran TEXT, '
      'materiTopikPembelajaran TEXT, '
      'kegiatanPembelajaran TEXT, '
      'dimensiProfilPelajarPancasila TEXT, '
      'createdAt TEXT)',
    );
  }
}
