import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String dbName = 'carrent_app.db';

  DBHelper._init();
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  factory DBHelper() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase(dbName);
    return _database!;
  }

  Future<Database> _initDatabase(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        nik TEXT NOT NULL,
        email TEXT NOT NULL,
        telepon TEXT NOT NULL,
        alamat TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        carName TEXT NOT NULL,
        penyewa TEXT NOT NULL,
        lamaSewa INTEGER NOT NULL,
        tglSewa TEXT NOT NULL,
        totalBiaya INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<int> registerUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('users', row);
  }

  Future<Map<String, dynamic>?> login(String user, String pass) async {
    final db = await instance.database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [user, pass],
    );

    if (res.isNotEmpty) return res.first;
    return null;
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await instance.database;
    final res = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  Future<int> addTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('transactions', row);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await instance.database;
    return await db.query('transactions', orderBy: 'id DESC');
  }

  Future<int> updateTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'transactions',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
