import 'package:flutter/material.dart';
import 'package:odev/data/menu.dart';

import '../cart_view/cart_view.dart';

class MenuView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const MenuView(this.phoneWidth, this.phoneHeight, {Key? key}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

double cartFullPrice = 0;

Future<int> getQuantity(Yemekler targetFood) async {
  List<Map> foodQuantity = await sqlDB.readData("SELECT food_quantity FROM 'foodMenu1' WHERE name = '${targetFood.foodName}'");
  print("Got quantity in getter: ${foodQuantity[0]['food_quantity']}");
  return foodQuantity[0]['food_quantity'];
}

Future<int> setQuantity(int quantity, Yemekler targetFood) async {
  if (quantity < 0) {
    return 0;
  }
  await sqlDB.updateData("UPDATE 'foodMenu1' SET 'food_quantity' = '$quantity' WHERE name = '${targetFood.foodName}'");
  print("set quantity: $quantity");
  return 0;
}

Future<int> addQuantity(Yemekler targetFood) async {
  List<Map> food = await sqlDB.readData("SELECT * FROM 'foodMenu1' WHERE name = '${targetFood.foodName}'");
  if (food[0]['availability'] == 1) {
    int quantity = await getQuantity(targetFood) + 1;
    await setQuantity(quantity, targetFood);
    await addToCart(targetFood);
    await loadDataFromDB();
    return 1;
  }
  return 0;
}

Future<double> calculateCartPrice() async {
  List<Map> foodQuantityPrice = await sqlDB.readData("SELECT total_price FROM 'cartMenu1'");
  cartFullPrice = 0;
  for (int i = 0; i < foodQuantityPrice.length; i++) {
    cartFullPrice += foodQuantityPrice[i]['total_price'];
  }
  return cartFullPrice;
}

Future<int> addToCart(Yemekler targetFood) async {
  List<Map> food = await sqlDB.readData("SELECT * FROM 'foodMenu1' WHERE name = '${targetFood.foodName}'");
  await sqlDB.deleteData("DELETE FROM 'cartMenu1' WHERE id = ${food[0]['id']}");
  await sqlDB.insertData("INSERT INTO 'cartMenu1' "
      "('id', 'name', 'price', 'food_quantity', 'total_price', 'table_id') "
      "VALUES (${food[0]['id']}, '${food[0]['name']}', '${food[0]['price']}', '${food[0]['food_quantity']}' , "
      "${food[0]['food_quantity'] * food[0]['price']}, 402)");
  return 0;
}

// TODO use table names
Future<int> printTableLogs() async {
  List<Map> foodResponse = await sqlDB.readData("SELECT * FROM 'foodMenu1'");
  print("Menu");
  print(foodResponse);

  List<Map> cartResponse = await sqlDB.readData("SELECT * FROM 'cartMenu1'");
  print("Cart");
  print(cartResponse);

  List<Map> checkoutResponse = await sqlDB.readData("SELECT * FROM 'lastOrder'");
  print("Checkout");
  print(checkoutResponse);
  return 0;
}

Future<int> deleteFood(Yemekler targetFood) async {
  // delete a single product
  await sqlDB.deleteData("DELETE FROM 'foodMenu1' WHERE name = '${targetFood.foodName}'");
  // await sqlDB.deleteData("DELETE FROM 'cartMenu1' WHERE name = '${targetFood.foodName}'");
  return 0;
}

class _MenuViewState extends State<MenuView> {
  String? _error;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MENU"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: FutureBuilder(
          future: calculateCartPrice(),
          builder: (context, snapshot) {
            return Padding(
              padding: EdgeInsets.only(top: widget.phoneHeight * 0.03, left: widget.phoneWidth * 0.03),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  "Aşağıdaki alana masa numaranızı giriniz:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                selectingTable(),
                Expanded(
                  child: ListView(physics: BouncingScrollPhysics(), children: [
                    corbaListView(),
                    salataListView(),
                    zeytinListView(),
                    araListView(),
                    anaListView(),
                    iceceklerListView(),
                    tatlilarListView(),
                  ]),
                ),
              ]),
            );
          },
        )));
  }

  Column corbaListView() {
    return Column(children: [
      Container(alignment: Alignment.centerLeft, child: const Text("Çorbalar:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: corba.length,
          itemBuilder: (context, index) {
            bool available = true;
            Yemekler yemek = corba[index];
            if (yemek.availability == 0) {
              available = false;
            }
            return listView(index, corba, available);
          }),
    ]);
  }

  Column salataListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(top: widget.phoneHeight * 0.03, bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Salatalar:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: salata.length,
          itemBuilder: (context, index) {
            bool available = true;
            Yemekler yemek = salata[index];
            if (yemek.availability == 0) {
              available = false;
            }
            return listView(index, salata, available);
          }),
    ]);
  }

  Column zeytinListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(top: widget.phoneHeight * 0.03, bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Zeytinyağlılar:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: zeytin.length,
          itemBuilder: (context, index) {
            bool available = true;
            Yemekler yemek = zeytin[index];
            if (yemek.availability == 0) {
              available = false;
            }
            return listView(index, zeytin, available);
          }),
    ]);
  }

  Column araListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(top: widget.phoneHeight * 0.03, bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Ara Sıcaklar:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: ara.length,
          itemBuilder: (context, index) {
            bool available = true;
            Yemekler yemek = ara[index];
            if (yemek.availability == 0) {
              available = false;
            }
            return listView(index, ara, available);
          }),
    ]);
  }

  Column anaListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(top: widget.phoneHeight * 0.03, bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Ana Yemekler:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: ana.length,
          itemBuilder: (context, index) {
            bool available = true;
            Yemekler yemek = ana[index];
            if (yemek.availability == 0) {
              available = false;
            }
            return listView(index, ana, available);
          }),
    ]);
  }

  Column iceceklerListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(top: widget.phoneHeight * 0.03, bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("İçecekler:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: icecekler.length,
          itemBuilder: (context, index) {
            bool available = true;
            Yemekler yemek = icecekler[index];
            if (yemek.availability == 0) {
              available = false;
            }
            return listView(index, icecekler, available);
          }),
    ]);
  }

  Column tatlilarListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(top: widget.phoneHeight * 0.03, bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Tatlılar:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: tatlilar.length,
          itemBuilder: (context, index) {
            bool available = true;
            Yemekler yemek = tatlilar[index];
            if (yemek.availability == 0) {
              available = false;
            }
            return listView(index, tatlilar, available);
          }),
    ]);
  }

  Column listView(int index, List type, bool available) {
    Yemekler yemek = type[index];
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(yemek.foodName, maxLines: 1, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("${yemek.foodPrice} TL", style: const TextStyle(fontSize: 20)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              decoration:
                  BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.blue.shade200)),
              width: widget.phoneWidth * 0.1,
              height: widget.phoneHeight * 0.04,
              alignment: Alignment.center,
              child: Text("${yemek.quantity}", style: const TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.only(right: widget.phoneWidth * 0.03, left: widget.phoneWidth * 0.03),
              child: ElevatedButton(
                onPressed: () async {
                  if (isReadOnly) {
                    await loadDataFromDB();
                    int additionResponse = await addQuantity(yemek);
                    if (additionResponse == 1) {
                      print("added quantity");
                    } else {
                      print("didn't add");
                    }
                    int quantity = await getQuantity(yemek);
                    await loadDataFromDB();
                    setState(() {
                      yemek.quantity = quantity;
                    });
                    double cartFullPrice = await calculateCartPrice();
                    setState(() {
                      cartFullPrice = cartFullPrice;
                    });
                    // await loadDataFromDB();
                    // await printTableLogs();
                  } else {
                    setState(() {
                      _error = "Lütfen bir masaya oturun!";
                    });
                  }
                  // await loadDataFromDB();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: available ? Colors.blue : Colors.grey,
                ),
                child: const Text("Ekle", style: TextStyle(fontSize: 20)),
              ),
            ),
          ])
        ],
      ),
    ]);
  }

  Padding selectingTable() {
    return Padding(
        padding: EdgeInsets.only(bottom: widget.phoneHeight * 0.01),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Text(
                  "MASA -",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: widget.phoneHeight * 0.04,
                  width: widget.phoneWidth * 0.15,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: tableID,
                    readOnly: isReadOnly,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      hintText: table.toString(),
                      hintStyle: const TextStyle(fontSize: 20.0, color: Colors.black87),
                    ),
                  ),
                ),
              ]),
              Padding(
                padding: EdgeInsets.only(right: widget.phoneWidth * 0.03),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        try {
                          tableId = int.parse(tableID.text);
                        } catch (e) {
                          setState(() {
                            _error = "Lütfen geçerli bir karakter girin!";
                          });
                          return;
                        }
                        if (tableId! > 0 && tableId! < 200) {
                          table = tableId;
                          isReadOnly = true;
                          setState(() {
                            _error = "";
                          });
                        } else {
                          setState(() {
                            _error = "Lütfen geçerli bir masa numarası seçin!";
                          });
                        }
                      });
                    },
                    child: const Text("Otur", style: TextStyle(fontSize: 20))),
              )
            ],
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: widget.phoneWidth * 0.03),
              child: Text(_error ?? "", style: const TextStyle(fontSize: 20, color: Colors.red))),
        ]));
  }
}
