import 'package:flutter/material.dart';

import '../../data/menu.dart';
import '../menu_view/menu_view.dart';

class LastOrderView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const LastOrderView(this.phoneWidth, this.phoneHeight, {Key? key}) : super(key: key);

  @override
  State<LastOrderView> createState() => _LastOrderViewState();
}

Future<int> checkOutCart() async {
  await sqlDB.deleteData("DELETE FROM 'lastOrder'");
  for (int i = 0; i < cartList.length; i++) {
    Yemekler food = cartList[i];
    List<Map> foodInfo = await sqlDB.readData("SELECT * FROM 'cartMenu1' WHERE name = '${food.foodName}'");
    // print(foodInfo[0]);
    await sqlDB.insertData("INSERT INTO 'lastOrder' "
        "('id', 'name', 'price', 'food_quantity', 'total_price', 'table_id') "
        "VALUES (${foodInfo[0]['id']}, '${foodInfo[0]['name']}', '${foodInfo[0]['price']}', '${foodInfo[0]['food_quantity']}' , "
        "${await calculateCartPrice()}, 402)");
    // print(await calculateCartPrice());
  }
  return 0;
}

Future<double> getCheckOutCartPrice() async {
    List<Map> foodInfo = await sqlDB.readData("SELECT total_price FROM 'lastOrder'");
    print(foodInfo[0]['total_price']);
    // await sqlDB.insertData("INSERT INTO 'lastOrder' "
    //     "('id', 'name', 'price', 'food_quantity', 'total_price', 'table_id') "
    //     "VALUES (${foodInfo[0]['id']}, '${foodInfo[0]['name']}', '${foodInfo[0]['price']}', '${foodInfo[0]['food_quantity']}' , "
    //     "${await calculateCartPrice()}, 402)");
    lastOrderCartPrice = foodInfo[0]['total_price'];
    return foodInfo[0]['total_price'];
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
        body: Padding(
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
                  padding: EdgeInsets.symmetric(vertical: widget.phoneHeight * 0.02),
                  decoration:
                  BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.blue.shade200)),
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
            ])));
  }

  // ListView lastOrderDetails() {
  //   return ListView(shrinkWrap: true, children: [
  //     Padding(
  //       padding: EdgeInsets.only(left: widget.phoneWidth * 0.02),
  //       child: Column(children: [
  //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //           Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: const [
  //             Text("Mercimek Çorbası", maxLines: 1, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //             Text("0.00 TL", style: TextStyle(fontSize: 20)),
  //           ]),
  //           Container(
  //             margin: EdgeInsets.only(right: widget.phoneWidth * 0.03),
  //             decoration:
  //                 BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.blue.shade200)),
  //             width: widget.phoneWidth * 0.1,
  //             height: widget.phoneHeight * 0.04,
  //             alignment: Alignment.center,
  //             child: const Text("1", style: TextStyle(fontSize: 20)),
  //           ),
  //         ]),
  //       ]),
  //     )
  //   ]);
  // }

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
              decoration:
              BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.blue.shade200)),
              width: widget.phoneWidth * 0.2,
              height: widget.phoneHeight * 0.06,
              alignment: Alignment.center,
              child: Text("${yemek.quantity}", style: const TextStyle(fontSize: 20)),
            ),
            // Padding(
            //   padding: EdgeInsets.only(right: widget.phoneWidth * 0.03, left: widget.phoneWidth * 0.03),
            //   child: ElevatedButton(
            //       onPressed: () async {
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.blue,
            //       ),
            //       child: const Text("Ekle", style: TextStyle(fontSize: 20))),
            // ),
          ])
        ],
      ),
    ]);
  }
}
