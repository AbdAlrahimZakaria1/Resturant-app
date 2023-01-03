import 'package:odev/DB/sqlDB.dart';

class Yemekler {
  int quantity, categoryID, availability;
  double foodPrice;
  String foodName;

  Yemekler(this.foodName, this.foodPrice, this.quantity, this.categoryID, this.availability);
}

SqlDB sqlDB = SqlDB();

loadDataFromDB() async {
  corba = [];
  salata = [];
  zeytin = [];
  ara = [];
  ana = [];
  icecekler = [];
  tatlilar = [];
  List<Map> menuData = await sqlDB.readData("SELECT * FROM $FOOD_MENU");
  cartList = [];
  for (int i = 0; i < menuData.length; i++) {
    if (menuData[i]['category_id'] == 101) {
      corba.add(Yemekler(menuData[i]['food_name'], menuData[i]['food_price'], menuData[i]['food_quantity'], 101, menuData[i]['availability']));
    } else if (menuData[i]['category_id'] == 102) {
      salata.add(Yemekler(menuData[i]['food_name'], menuData[i]['food_price'], menuData[i]['food_quantity'], 102, menuData[i]['availability']));
    } else if (menuData[i]['category_id'] == 103) {
      zeytin.add(Yemekler(menuData[i]['food_name'], menuData[i]['food_price'], menuData[i]['food_quantity'], 103, menuData[i]['availability']));
    } else if (menuData[i]['category_id'] == 104) {
      ara.add(Yemekler(menuData[i]['food_name'], menuData[i]['food_price'], menuData[i]['food_quantity'], 104, menuData[i]['availability']));
    } else if (menuData[i]['category_id'] == 105) {
      ana.add(Yemekler(menuData[i]['food_name'], menuData[i]['food_price'], menuData[i]['food_quantity'], 105, menuData[i]['availability']));
    } else if (menuData[i]['category_id'] == 106) {
      icecekler.add(Yemekler(menuData[i]['food_name'], menuData[i]['food_price'], menuData[i]['food_quantity'], 106, menuData[i]['availability']));
    } else if (menuData[i]['category_id'] == 107) {
      tatlilar.add(Yemekler(menuData[i]['food_name'], menuData[i]['food_price'], menuData[i]['food_quantity'], 107, menuData[i]['availability']));
    }
    if (menuData[i]['food_quantity'] > 0) {
      cartList
          .add(Yemekler(menuData[i]['food_name'], menuData[i]['food_price'], menuData[i]['food_quantity'], menuData[i]['category_id'], menuData[i]['availability']));
    }
  }
  List<Map> checkoutData = await sqlDB.readData("SELECT * FROM $LAST_ORDER_MENU");
  checkoutOrderList = [];
  for (int i = 0; i < checkoutData.length; i++) {
    checkoutOrderList.add(Yemekler(checkoutData[i]['food_name'], checkoutData[i]['food_price'], checkoutData[i]['food_quantity'], -1, 1));
  }
  print("loaded data from DB");
}

List cartList = [];
List checkoutOrderList = [];

List corba = [];
List salata = [];
List zeytin = [];
List ara = [];
List ana = [];
List icecekler = [];
List tatlilar = [];
