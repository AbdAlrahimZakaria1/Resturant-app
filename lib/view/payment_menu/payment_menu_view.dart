import 'package:flutter/material.dart';
import 'package:odev/data/menu.dart';
import 'package:odev/view/menu_view/menu_view.dart';
import '../../DB/sqlDB.dart';
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
  TextEditingController foodName = new TextEditingController();
  TextEditingController foodPrice = new TextEditingController();
  SqlDB sqlDB = SqlDB();
  String dropdownValue = 'Corba';
  bool confBtnIsChecked = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("ÖDEME"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: widget.phoneHeight * 0.2, left: widget.phoneWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kart Üzerindeki İsim",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            CartNameTextField(),
            const Text(
              "Kart Numarası",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            CartNumberTextField(),
            PaymentButton(),
            errorBox()
          ],
        ),
      ),
    );
  }

  Container CartNameTextField() {
    return Container(
      margin: EdgeInsets.only(top: widget.phoneHeight * 0.01, bottom: widget.phoneHeight * 0.02),
      height: widget.phoneHeight * 0.05,
      width: widget.phoneWidth * 0.94,
      child: TextField(
        maxLines: 1,
        controller: foodName,
        decoration: const InputDecoration(
          hintText: "Ad Soyad",
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Container CartNumberTextField() {
    return Container(
      margin: EdgeInsets.only(
        top: widget.phoneHeight * 0.01,
      ),
      height: widget.phoneHeight * 0.05,
      width: widget.phoneWidth * 0.94,
      child: TextField(
        controller: foodPrice,
        maxLines: 1,
        decoration: const InputDecoration(
          hintText: "0000 **** **** ****",
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
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
            // await loadDataFromDB();
            // await printTableLogs();
            // await addPassiveList();
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
          child: const Text("Ödeme Yap", style: TextStyle(fontSize: 25))),
    );
  }

  Container errorBox() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(right: widget.phoneWidth * 0.03),
      child: Text(_error ?? "", style: const TextStyle(fontSize: 20, color: Colors.red)),
    );
  }
}

List<String> dropDownMenuItems = ['Corba', 'Salata', 'Zeytinyağlılar', 'Ara Sıcaklar', 'Ana Yemekler', 'İçecekler', 'Tatlılar'];
