import 'package:flutter/material.dart';
import 'package:odev/DB/sqlDB.dart';
import '../../data/menu.dart';

class LastOrderView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const LastOrderView(this.phoneWidth, this.phoneHeight, {Key? key}) : super(key: key);

  @override
  State<LastOrderView> createState() => _LastOrderViewState();
}
Future<int> tablesInitialization() async {
  // delete content from last order table
  await sqlDB.deleteData("DELETE FROM $LAST_ORDER_MENU");

  // update all quantities to 0
  await sqlDB.updateData("UPDATE $FOOD_MENU SET 'food_quantity' = 0");
  await sqlDB.updateData("UPDATE $CART_MENU SET 'food_quantity' = 0");
  await sqlDB.updateData("UPDATE $CART_MENU SET 'total_price' = 0");

  print("tables initialized");
  return 0;
}

Future<int> checkOutCart() async {
  for (int i = 0; i < cartList.length; i++) {
    Yemekler food = cartList[i];
    List<Map> foodQuantity = await sqlDB.readData("SELECT * FROM $LAST_ORDER_MENU WHERE food_name = '${food.foodName}'");
    if (foodQuantity.isNotEmpty) {
      int quantity = foodQuantity[0]['food_quantity'];
      print(quantity);
      List<Map> foodInfo = await sqlDB.readData("SELECT * FROM $CART_MENU WHERE food_name = '${food.foodName}'");
      await sqlDB.deleteData("DELETE FROM $LAST_ORDER_MENU WHERE food_name = '${food.foodName}'");
      await sqlDB.insertData("INSERT INTO $LAST_ORDER_MENU "
          "('food_id', 'food_name', 'food_price', 'food_quantity', 'total_price') "
          "VALUES (${foodInfo[0]['food_id']}, '${foodInfo[0]['food_name']}', '${foodInfo[0]['food_price']}', '${foodInfo[0]['food_quantity'] + quantity}', "
          "${foodInfo[0]['food_price'] * (foodInfo[0]['food_quantity'] + quantity)})");
    } else {
      List<Map> foodInfo = await sqlDB.readData("SELECT * FROM $CART_MENU WHERE food_name = '${food.foodName}'");
      await sqlDB.insertData("INSERT INTO $LAST_ORDER_MENU "
          "('food_id', 'food_name', 'food_price', 'food_quantity', 'total_price') "
          "VALUES (${foodInfo[0]['food_id']}, '${foodInfo[0]['food_name']}', '${foodInfo[0]['food_price']}', '${foodInfo[0]['food_quantity']}', "
          "${foodInfo[0]['food_price'] * foodInfo[0]['food_quantity']})");
    }
    await getCheckOutCartPrice();
  }
  return 0;
}

Future<double> getCheckOutCartPrice() async {
  List<Map> foodInfo = await sqlDB.readData("SELECT * FROM $LAST_ORDER_MENU");
  if (foodInfo.isEmpty) {
    return 0.00;
  }
  double price = 0;
  for (int i = 0; i < foodInfo.length; i++) {
    price += foodInfo[i]['total_price'];
  }
  lastOrderCartPrice = price;
  return price;
}

double lastOrderCartPrice = 0;

class _LastOrderViewState extends State<LastOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GEÇMİŞ"),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
          future: getCheckOutCartPrice(),
          builder: (context, snapshot) {
            return Padding(
                padding: EdgeInsets.only(top: widget.phoneHeight * 0.2),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(left: widget.phoneWidth * 0.02, bottom: widget.phoneHeight * 0.02),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Son Siparis:",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      width: widget.phoneWidth * 0.94,
                      padding: EdgeInsets.symmetric(vertical: widget.phoneHeight * 0.02, horizontal: widget.phoneWidth * 0.05),
                      decoration: BoxDecoration(
                          color: Colors.blue[50], borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.blue.shade200)),
                      child: Column(children: [
                        lastOrderListView(),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: widget.phoneHeight * 0.02, left: widget.phoneWidth * 0.02),
                          child: Text(
                            "Toplam: $lastOrderCartPrice TL",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      ]))
                ]));
          },
        ));
  }

  Column lastOrderListView() {
    return Column(children: [
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: checkoutOrderList.length,
          itemBuilder: (context, index) {
            return listView(index, checkoutOrderList);
          }),
    ]);
  }

  Column listView(int index, List type) {
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.blue.shade200)),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Text("${yemek.quantity}", style: const TextStyle(fontSize: 20)),
            ),
          ])
        ],
      ),
    ]);
  }
}
