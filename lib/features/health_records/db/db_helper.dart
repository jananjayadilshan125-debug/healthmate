import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_record.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('healthmate.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        steps INTEGER,
        calories INTEGER,
        water INTEGER
      )
    ''');
  }

  Future<int> insertRecord(HealthRecord record) async {
    final db = await instance.database;
    return await db.insert('health_records', record.toMap());
  }

  Future<List<HealthRecord>> getRecords() async {
    final db = await instance.database;
    final result = await db.query('health_records', orderBy: 'date DESC');
    return result.map((e) => HealthRecord.fromMap(e)).toList();
  }

  Future<int> updateRecord(HealthRecord record) async {
    final db = await instance.database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return db.delete('health_records', where: 'id = ?', whereArgs: [id]);
  }
}
