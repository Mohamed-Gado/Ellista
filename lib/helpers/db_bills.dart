import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DbBills {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'bills.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_bills(id TEXT PRIMARY KEY, totalPrice REAL, names TEXT, quantity TEXT, prices TEXT, time Text)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbBills.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbBills.database();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DbBills.database();
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
