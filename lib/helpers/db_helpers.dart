import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'products.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_products(id TEXT PRIMARY KEY, title TEXT, price REAL, category TEXT, notes TEXT, codeContent TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(Map<String, dynamic> newProduct, String id) async {
    final db = await DBHelper.database();
    return await db.update(
      'user_products',
      newProduct,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
