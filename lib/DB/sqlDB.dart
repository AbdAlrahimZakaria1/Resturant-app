import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String FOOD_MENU = 'food_menu';
String CART_MENU = 'cart_menu';
String LAST_ORDER_MENU = 'last_order';
String FOOD_CATEGORY = 'food_category';

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
    Database myDB = await openDatabase(path, onCreate: _onCreate, version: 36, onUpgrade: _onUpgrade);
    return myDB;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade ==========");
    // await db.execute('''
    //   CREATE TABLE $FOOD_MENU (
    //   "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
    //   "food_name" TEXT NOT NULL,
    //   "food_price" REAL NOT NULL,
    //   "food_quantity" INTEGER NOT NULL,
    //   "category_id" INTEGER NOT NULL,
    //   "availability" INTEGER NOT NULL,
    //   "manager_id" INTEGER NOT NULL
    //   )
    //   ''');
    // await db.execute('''
    //   CREATE TABLE $CART_MENU (
    //   "food_id" INTEGER NOT NULL,
    //   "food_name" TEXT NOT NULL,
    //   "food_price" REAL NOT NULL,
    //   "food_quantity" INTEGER NOT NULL,
    //   "total_price" REAL NOT NULL
    //   )
    //   ''');
    // await db.execute('''
    //   CREATE TABLE $LAST_ORDER_MENU (
    //   "food_id" INTEGER  NOT NULL,
    //   "food_name" TEXT NOT NULL,
    //   "food_price" REAL NOT NULL,
    //   "food_quantity" INTEGER NOT NULL,
    //   "total_price" REAL NOT NULL
    //   )
    // ''');
    // await db.execute('''
    //   CREATE TABLE $FOOD_CATEGORY (
    //   "category_id" INTEGER NOT NULL,
    //   "category_name" TEXT NOT NULL
    //   )
    // ''');
    await db.execute('''
      INSERT INTO $FOOD_CATEGORY (category_id, category_name)
      VALUES (101, "Corba"),
             (102, "Salata"),
             (103, "Zeytinyağlılar"),
             (104, "Ara Sıcaklar"),
             (105, "Ana Yemekler"),
             (106, "İçecekler"),
             (107, "Tatlılar")
    ''');
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $FOOD_MENU (
      "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
      "food_name" TEXT NOT NULL,
      "food_price" REAL NOT NULL,
      "food_quantity" INTEGER NOT NULL,
      "category_id" INTEGER NOT NULL,
      "availability" INTEGER NOT NULL,
      "manager_id" INTEGER NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $CART_MENU (
      "food_id" INTEGER NOT NULL,
      "food_name" TEXT NOT NULL,
      "food_price" REAL NOT NULL,
      "food_quantity" INTEGER NOT NULL,
      "total_price" REAL NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $LAST_ORDER_MENU (
      "food_id" INTEGER  NOT NULL,
      "food_name" TEXT NOT NULL,
      "food_price" REAL NOT NULL,
      "food_quantity" INTEGER NOT NULL,
      "total_price" REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $FOOD_CATEGORY (
      "category_id" INTEGER NOT NULL,
      "category_name" TEXT NOT NULL
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
