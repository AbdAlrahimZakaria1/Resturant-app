import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String FOOD_MENU = 'foodMenu1';
String CART_MENU = 'cartMenu1';
String LAST_ORDER_MENU = 'lastOrder';

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
        onCreate: _onCreate, version: 26, onUpgrade: _onUpgrade);
    return myDB;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async{
    print("_onUpgrade ==========");
    // if (oldVersion < newVersion){
    //   db.execute("ALTER TABLE 'foodMenu1' ADD COLUMN 'manager_id' INTEGER");
    // }
    // db.execute("alter table 'cartMenu' add column 'food_quantity' INTEGER");
    await db.execute('''
      CREATE TABLE "foodMenu1" (
      "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "type" TEXT NOT NULL,
      "availability" INTEGER NOT NULL,
      "manager_id" INTEGER NOT NULL,
      "food_quantity" INTEGER NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE "lastOrder" (
      "id" INTEGER  NOT NULL PRIMARY KEY,
      "name" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "food_quantity" INTEGER NOT NULL,
      "total_price" REAL NOT NULL,
      "table_id" INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE "cartMenu1" (
      "id" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "food_quantity" INTEGER NOT NULL,
      "total_price" REAL NOT NULL,
      "table_id" INTEGER NOT NULL
      )
      ''');
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "lastOrder" (
      "id" INTEGER  NOT NULL PRIMARY KEY,
      "name" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "food_quantity" INTEGER NOT NULL,
      "total_price" REAL NOT NULL,
      "table_id" INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE "foodMenu1" (
      "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "type" TEXT NOT NULL,
      "availability" INTEGER NOT NULL,
      "manager_id" INTEGER NOT NULL,
      "food_quantity" INTEGER NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE "cartMenu1" (
      "id" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "food_quantity" INTEGER NOT NULL,
      "total_price" REAL NOT NULL,
      "table_id" INTEGER NOT NULL
      )
      ''');
    print("_onCreate ==========");
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
