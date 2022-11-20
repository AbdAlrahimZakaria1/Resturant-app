import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDB {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  initialDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'lypo.db');
    Database myDB = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return myDB;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {}

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "foodMenu" (
      id INTEGER AUTOINCREMENT NOT NULL PRIMARY KEY,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      price REAL NOT NULL,
      )
      ''');
    print("CREATED DB");
  }

  readData(String sql) async {
    Database? myDB = await db;
    List<Map> response = await myDB!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawDelete(sql);
    return response;
  }
}
