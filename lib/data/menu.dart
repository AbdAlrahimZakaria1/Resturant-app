import 'package:odev/DB/sqlDB.dart';

class Yemekler {
  int quantity, availability;
  double foodPrice;
  String foodName, foodCategory;

  Yemekler(this.foodCategory, this.foodName, this.foodPrice, this.quantity, this.availability);
}

SqlDB sqlDB = SqlDB();

loadDataFromDB() async {
  corba = [
    // Yemekler("Çorba", "Mercimek Çorbası", 12.00, 0, 0),
    // Yemekler("Çorba", "Tarhana Çorbası", 12.00, 0),
    // Yemekler("Çorba", "Domates Çorbası", 12.00, 0),
  ];
  salata = [
    // Yemekler("Salata", "Çoban Salata", 10.00, 0),
    // Yemekler("Salata", "Mevsim Salata", 11.00, 0),
  ];
  zeytin = [
    // Yemekler("Zeytinyağlılar", "Biber Dolma", 15.00, 0),
    // Yemekler("Zeytinyağlılar", "Soslu Patlıcan", 15.00, 0),
    // Yemekler("Zeytinyağlılar", "Enginar", 17.00, 0),
  ];
  ara = [
    // Yemekler("Ara Sıcaklar", "Patates Tava", 10.00, 0),
    // Yemekler("Ara Sıcaklar", "Paçanga Böreği", 12.00, 0),
    // Yemekler("Ara Sıcaklar", "Sigara Böreği", 12.00, 0),
    // Yemekler("Ara Sıcaklar", "Mantar Kavurma", 16.00, 0),
    // Yemekler("Ara Sıcaklar", "Mantar Graten", 16.00, 0),
  ];
  ana = [
    // Yemekler("Ana Yemekler", "Köfte Izgara", 38.00, 0),
    // Yemekler("Ana Yemekler", "Kaşarlı Köfte Izgara", 40.00, 0),
    // Yemekler("Ana Yemekler", "Piliç Izgara", 35.00, 0),
    // Yemekler("Ana Yemekler", "Piliç Kavurma", 35.00, 0),
    // Yemekler("Ana Yemekler", "Bonfile", 96.00, 0),
    // Yemekler("Ana Yemekler", "Karışık Izgara", 68.00, 0),
    // Yemekler("Ana Yemekler", "Çoban Kavurma", 55.00, 0),
  ];
  icecekler = [
    // Yemekler("İçecekler", "Kutu İçecekler", 6.50, 0),
    // Yemekler("İçecekler", "Ayran", 4.00, 0),
    // Yemekler("İçecekler", "Soda", 4.50, 0),
    // Yemekler("İçecekler", "Çay", 3.50, 0),
    // Yemekler("İçecekler", "Türk Kahvesi", 10.00, 0),
    // Yemekler("İçecekler", "Su", 1.50, 0),
  ];
  tatlilar = [
    // Yemekler("Tatlılar", "Sütlaç", 13.00, 0),
    // Yemekler("Tatlılar", "Trileçe", 15.00, 0),
    // Yemekler("Tatlılar", "Dondurma", 10.00, 0),
    // Yemekler("Tatlılar", "Meyve Tabağı", 15.00, 0),
  ];
  List<Map> menuData = await sqlDB.readData("SELECT * FROM 'foodMenu1'");
  cartList = [];
  for (int i = 0; i < menuData.length; i++) {
    if (menuData[i]['type'] == 'Çorba') {
      corba.add(Yemekler("Çorba", menuData[i]['name'], menuData[i]['price'], menuData[i]['food_quantity'], menuData[i]['availability']));
    } else if (menuData[i]['type'] == 'Salata') {
      salata.add(Yemekler("Salata", menuData[i]['name'], menuData[i]['price'], menuData[i]['food_quantity'], menuData[i]['availability']));
    } else if (menuData[i]['type'] == 'Zeytinyağlı') {
      zeytin.add(Yemekler(
          "Zeytinyağlılar", menuData[i]['name'], menuData[i]['price'], menuData[i]['food_quantity'], menuData[i]['availability']));
    } else if (menuData[i]['type'] == 'Ara Sıcak') {
      ara.add(
          Yemekler("Ara Sıcaklar", menuData[i]['name'], menuData[i]['price'], menuData[i]['food_quantity'], menuData[i]['availability']));
    } else if (menuData[i]['type'] == 'Ana Yemek') {
      ana.add(
          Yemekler("Ana Yemekler", menuData[i]['name'], menuData[i]['price'], menuData[i]['food_quantity'], menuData[i]['availability']));
    } else if (menuData[i]['type'] == 'İçecek') {
      icecekler.add(
          Yemekler("İçecekler", menuData[i]['name'], menuData[i]['price'], menuData[i]['food_quantity'], menuData[i]['availability']));
    } else if (menuData[i]['type'] == 'Tatlı') {
      tatlilar
          .add(Yemekler("Tatlılar", menuData[i]['name'], menuData[i]['price'], menuData[i]['food_quantity'], menuData[i]['availability']));
    }
    if (menuData[i]['food_quantity'] > 0){
      cartList.add(Yemekler(menuData[i]['name'], menuData[i]['name'], menuData[i]['price'], menuData[i]['food_quantity'], menuData[i]['availability']));
    }
  }
  List<Map> checkoutData = await sqlDB.readData("SELECT * FROM 'lastOrder'");
  checkoutOrderList = [];
  for (int i = 0; i < checkoutData.length; i++) {
    checkoutOrderList.add(Yemekler(checkoutData[i]['name'], checkoutData[i]['name'], checkoutData[i]['price'], checkoutData[i]['food_quantity'], 1));
  }
  print("loaded data from DB");
}

List cartList = [];
List checkoutOrderList = [];

List corba = [
  // Yemekler("Çorba", "Mercimek Çorbası", 12.00, 0),
  // Yemekler("Çorba", "Tarhana Çorbası", 12.00, 0),
  // Yemekler("Çorba", "Domates Çorbası", 12.00, 0),
];
List salata = [
  // Yemekler("Salata", "Çoban Salata", 10.00, 0),
  // Yemekler("Salata", "Mevsim Salata", 11.00, 0),
];
List zeytin = [
  // Yemekler("Zeytinyağlılar", "Biber Dolma", 15.00, 0),
  // Yemekler("Zeytinyağlılar", "Soslu Patlıcan", 15.00, 0),
  // Yemekler("Zeytinyağlılar", "Enginar", 17.00, 0),
];
List ara = [
  // Yemekler("Ara Sıcaklar", "Patates Tava", 10.00, 0),
  // Yemekler("Ara Sıcaklar", "Paçanga Böreği", 12.00, 0),
  // Yemekler("Ara Sıcaklar", "Sigara Böreği", 12.00, 0),
  // Yemekler("Ara Sıcaklar", "Mantar Kavurma", 16.00, 0),
  // Yemekler("Ara Sıcaklar", "Mantar Graten", 16.00, 0),
];
List ana = [
  // Yemekler("Ana Yemekler", "Köfte Izgara", 38.00, 0),
  // Yemekler("Ana Yemekler", "Kaşarlı Köfte Izgara", 40.00, 0),
  // Yemekler("Ana Yemekler", "Piliç Izgara", 35.00, 0),
  // Yemekler("Ana Yemekler", "Piliç Kavurma", 35.00, 0),
  // Yemekler("Ana Yemekler", "Bonfile", 96.00, 0),
  // Yemekler("Ana Yemekler", "Karışık Izgara", 68.00, 0),
  // Yemekler("Ana Yemekler", "Çoban Kavurma", 55.00, 0),
];
List icecekler = [
  // Yemekler("İçecekler", "Kutu İçecekler", 6.50, 0),
  // Yemekler("İçecekler", "Ayran", 4.00, 0),
  // Yemekler("İçecekler", "Soda", 4.50, 0),
  // Yemekler("İçecekler", "Çay", 3.50, 0),
  // Yemekler("İçecekler", "Türk Kahvesi", 10.00, 0),
  // Yemekler("İçecekler", "Su", 1.50, 0),
];
List tatlilar = [
  // Yemekler("Tatlılar", "Sütlaç", 13.00, 0),
  // Yemekler("Tatlılar", "Trileçe", 15.00, 0),
  // Yemekler("Tatlılar", "Dondurma", 10.00, 0),
  // Yemekler("Tatlılar", "Meyve Tabağı", 15.00, 0),
];
