import 'package:flutter/material.dart';
import 'package:odev/data/menu.dart';
import 'package:odev/view/menu_view/menu_view.dart';
import '../../DB/sqlDB.dart';
import '../../view_model/bottom_nav_bar/bottom_nav_bar_model.dart';
import '../last_orders_view/last_order_view.dart';
import '../yemek_pasife_al_view/yemek_pasife_al_view.dart';
import 'package:validators/validators.dart';

class PaymentMenuView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const PaymentMenuView(this.phoneWidth, this.phoneHeight, {Key? key}) : super(key: key);

  @override
  State<PaymentMenuView> createState() => _PaymentMenuViewState();
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
class _PaymentMenuViewState extends State<PaymentMenuView> {
  TextEditingController cardName = new TextEditingController();
  TextEditingController cardNumber = new TextEditingController();
  TextEditingController cardLastDate = new TextEditingController();
  TextEditingController cvc = new TextEditingController();

  SqlDB sqlDB = SqlDB();
  String dropdownValue = 'Corba';
  bool confBtnIsChecked = false;
  String? _error;
  MaterialColor colorError = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("ÖDEME"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.phoneWidth * 0.03) + EdgeInsets.only(top: widget.phoneHeight * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            textFieldTitle("Kart Üzerindeki İsim"),
            textFieldView(cardName, "Ad Soyad", 0.94),
            textFieldTitle("Kart Numarası"),
            textFieldView(cardNumber, "0000 **** **** ****", 0.94),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [textFieldTitle("Son Kullanma Tarihi"), textFieldView(cardLastDate, "MM/YY", 0.45)],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [textFieldTitle("CVC"), textFieldView(cvc, "***", 0.45)],
                ),
              ],
            ),
            PaymentButton(),
            errorBox()
          ],
        ),
      ),
    );
  }

  Widget textFieldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }

  Widget textFieldView(TextEditingController controller, String hintText, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: widget.phoneHeight * 0.02),
      width: widget.phoneWidth * width,
      child: TextField(
        maxLines: 1,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Container PaymentButton() {
    return Container(
      padding: EdgeInsets.only(top: widget.phoneHeight * 0.01),
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
          onPressed: () async {
            if (cardName.text.isEmpty || cardNumber.text.isEmpty || cardLastDate.text.isEmpty || cvc.text.isEmpty) {
              setState(() {
                _error = "Lütfen boş alanları doldurunuz!";
              });
              return;
            }

            if (!isAlpha(cardName.text)) {
              setState(() {
                _error = "Lütfen geçerli karakter girin!";
              });
              return;
            }
            if (!isNumeric(cardNumber.text)) {
              setState(() {
                _error = "Lütfen geçerli karakter girin!";
              });
              return;
            }
            if (cardNumber.text.length != 16) {
              setState(() {
                _error = "Lütfen geçerli bir kart numarası girin!";
              });
              return;
            }
            if (!isNumeric(cvc.text) || double.parse(cvc.text) < 0 || double.parse(cvc.text) > 999) {
              setState(() {
                _error = "Lütfen geçerli bir CVC kodu girin!";
              });
              return;
            }
            // if (!isNumeric(cardLastDate.text) || cardLastDate.text.length != 4) {
            //   setState(() {
            //     _error = "Lütfen geçerli bir tarih giriniz!";
            //   });
            //   return;
            // }
            colorError = Colors.green;
            setState(() {
              _error = "Siparişiniz Alındı!";
            });
            await addPassiveList();
            await loadDataFromDB();
            await checkOutCart();
            lastOrderCartPrice = await getCheckOutCartPrice();
            setState(() {
              lastOrderCartPrice = lastOrderCartPrice;
            });
            // await loadDataFromDB();
            await sqlDB.updateData("UPDATE $FOOD_MENU SET 'food_quantity' = 0");
            await sqlDB.updateData("UPDATE $CART_MENU SET 'food_quantity' = 0");
            await sqlDB.updateData("UPDATE $CART_MENU SET 'total_price' = 0");
            await loadDataFromDB();
            await printTableLogs();
            double cartFullPrice = await calculateCartPrice();
            setState(() {
              cartFullPrice = cartFullPrice;
            });
            await Future.delayed(Duration(seconds: 3));
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainBottomNavBar(widget.phoneWidth, widget.phoneHeight, 0)));            await Future.delayed(Duration(seconds: 3));
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
          child: const Text("Ödeme Yap", style: TextStyle(fontSize: 25))),
    );
  }

  Container errorBox() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(right: widget.phoneWidth * 0.03),
      child: Text(_error ?? "", style: TextStyle(fontSize: 20, color: colorError)),
    );
  }
}
