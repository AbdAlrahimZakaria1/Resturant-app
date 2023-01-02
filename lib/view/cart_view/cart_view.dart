import 'package:flutter/material.dart';
import 'package:odev/DB/sqlDB.dart';
import 'package:odev/view/menu_view/menu_view.dart';
import '../../data/menu.dart';
import '../last_orders_view/last_order_view.dart';
import '../payment_menu/payment_menu_view.dart';

class CartView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const CartView(this.phoneWidth, this.phoneHeight, {Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

Future<int> updateCartQuantity(Yemekler targetFood) async {
  List<Map> food = await sqlDB.readData("SELECT * FROM $FOOD_MENU WHERE food_name = '${targetFood.foodName}'");
  await sqlDB.deleteData("DELETE FROM $CART_MENU WHERE food_id = ${food[0]['id']}");
  int quantity = await getQuantity(targetFood);
  if (quantity > 0) {
    await sqlDB.insertData("INSERT INTO $CART_MENU "
        "('food_id', 'food_name', 'food_price', 'food_quantity', 'total_price')"
        "VALUES (${food[0]['id']}, '${food[0]['food_name']}', '${food[0]['food_price']}', '$quantity' , ${quantity * food[0]['food_price']})");
  }
  if (quantity == 0) {
    await sqlDB.deleteData("DELETE FROM $CART_MENU WHERE food_id = ${food[0]['id']}");
  }
  return 0;
}

Future<int> removeQuantity(Yemekler targetFood) async {
  int quantity = await getQuantity(targetFood) - 1;
  await setQuantity(quantity, targetFood);
  return 0;
}
dynamic tableId = '';
bool isReadOnly = false;
TextEditingController tableID = TextEditingController();
dynamic table = '';

class _CartViewState extends State<CartView> {
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEPET"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: widget.phoneHeight * 0.2, left: widget.phoneWidth * 0.03),
        child: Column(children: [
          sepetListView(),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: widget.phoneHeight * 0.02),
            child: Text(
              "Toplam: $cartFullPrice TL",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: widget.phoneHeight * 0.01),
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
                onPressed: () async {
                  if (cartList.isNotEmpty) {
                    await loadDataFromDB();
                    await checkOutCart();
                    lastOrderCartPrice = await getCheckOutCartPrice();
                    setState(() {
                      lastOrderCartPrice = lastOrderCartPrice;
                    });
                    await loadDataFromDB();
                    await printTableLogs();
                  }else{
                    setState(() {
                      _error = "Lütfen ürün seçiniz";
                    });
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMenuView(widget.phoneWidth, widget.phoneHeight)));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
                child: const Text("Siparis Ver", style: TextStyle(fontSize: 25))),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: widget.phoneWidth * 0.03),
              child: Text(_error ?? "", style: const TextStyle(fontSize: 20, color: Colors.red))),
        ]),
      ),
    );
  }

  Column sepetListView() {
    return Column(children: [
      ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: cartList.length,
          itemBuilder: (context, index) {
            return listView(index, cartList);
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
              width: widget.phoneWidth * 0.1,
              height: widget.phoneHeight * 0.04,
              alignment: Alignment.center,
              child: Text("${yemek.quantity}", style: const TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.only(right: widget.phoneWidth * 0.03, left: widget.phoneWidth * 0.03),
              child: ElevatedButton(
                  onPressed: () async {
                    await removeQuantity(yemek);
                    await updateCartQuantity(yemek);
                    int quantity = await getQuantity(yemek);
                    await loadDataFromDB();
                    await calculateCartPrice();
                    setState(() {
                      yemek.quantity = quantity;
                    });
                    yemek.quantity = quantity;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Sil", style: TextStyle(fontSize: 20))),
            ),
          ])
        ],
      ),
    ]);
  }
}
