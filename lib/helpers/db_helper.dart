import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

Future<sql.Database> _database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'), onCreate: (db, version) {
      return db.execute(
          '''CREATE TABLE user_places(
              id TEXT PRIMARY KEY, 
              title TEXT, 
              image TEXT,
              loc_lat REAL,
              loc_lng REAL,
              address TEXT)'''
      );
    }, version: 1);
  }

Future<void> insert(String table, Map<String, Object> data) async {
  final db = await _database();
  db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
}

Future<int> delete(String table, String id) async {
  final db = await _database();
  return db.delete(table, where: 'id = ?', whereArgs: [id]);
}

Future<List<Map<String, dynamic>>> getData(String table) async {
  final db = await _database();
  return db.query(table);
}