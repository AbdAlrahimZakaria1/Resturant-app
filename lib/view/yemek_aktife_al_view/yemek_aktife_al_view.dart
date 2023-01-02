import 'package:flutter/material.dart';
import 'package:odev/DB/sqlDB.dart';
import 'package:odev/view/menu_view/menu_view.dart';
import 'package:validators/validators.dart';

import '../../data/menu.dart';
import '../yemek_pasife_al_view/yemek_pasife_al_view.dart';

class YemekAktifeAlView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const YemekAktifeAlView(this.phoneWidth, this.phoneHeight, {Key? key}) : super(key: key);

  @override
  State<YemekAktifeAlView> createState() => _YemekAktifeAlViewState();
}

String dropdownActiveValue = '';
bool firstTime = true;

List<String> adminNames = ['Emre Güler', 'Abd Alrahim', 'Yüsra Kaplan'];

Future<int> addActiveList() async {
  dropDownActiveItems = [];
  List<Map> foodList = await sqlDB.readData("SELECT * FROM $FOOD_MENU WHERE availability = 0");
  if (foodList.isEmpty) {
    return 0;
  }
  for (int i = 0; i < foodList.length; i++) {
    if (foodList[i]['availability'] == 0) {
      dropDownActiveItems.add(foodList[i]['food_name']);
    }
  }
  if (firstTime) {
    print("seet");
    dropdownActiveValue = dropDownActiveItems[0];
    firstTime = false;
  }
  return 0;
}

Future<int> makeFoodActive(foodName, adminName) async {
  // List<Map> foodList = await sqlDB.readData("SELECT * FROM $FOOD_MENU WHERE food_name = ${targetFood.foodName}");
  for (int i = 0; i < adminNames.length; i++) {
    if (adminName == adminNames[i]) {
      await sqlDB.updateData("UPDATE $FOOD_MENU SET 'availability' = 1 WHERE food_name = '$foodName'");
      await addActiveList();
      await addPassiveList();
      return 1;
    }
  }
  return 0;
}

class _YemekAktifeAlViewState extends State<YemekAktifeAlView> {
  bool confBtnisChecked = false;
  TextEditingController adminName = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YEMEK AKTİFE AL"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: widget.phoneHeight * 0.2, left: widget.phoneWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Aktife alınacak yemeği seçin:",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            dropDownPassiveMenu(),
            const Text(
              "Yemek Aktife Alacak Yönetici",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            adSoyadTextField(),
            checkBox(),
            pasifeAlButton(),
            errorBox(),
          ],
        ),
      ),
    );
  }

  Container araTextField() {
    return Container(
      margin: EdgeInsets.only(
        top: widget.phoneHeight * 0.01,
        bottom: widget.phoneHeight * 0.02,
      ),
      height: widget.phoneHeight * 0.06,
      width: widget.phoneWidth * 0.75,
      child: TextField(
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: Align(
              widthFactor: widget.phoneWidth * 0.0001,
              heightFactor: widget.phoneHeight * 0.001,
              child: const Icon(
                Icons.search,
              )),
          hintText: "Ara",
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Container araButton() {
    return Container(
      margin: EdgeInsets.only(top: widget.phoneHeight * 0.01, bottom: widget.phoneHeight * 0.02, left: widget.phoneWidth * 0.032),
      height: widget.phoneHeight * 0.06,
      child: ElevatedButton(onPressed: () {}, child: const Text("Ara", style: TextStyle(fontSize: 20))),
    );
  }

  Container adSoyadTextField() {
    return Container(
      margin: EdgeInsets.only(top: widget.phoneHeight * 0.01),
      height: widget.phoneHeight * 0.06,
      width: widget.phoneWidth * 0.94,
      child: TextField(
        controller: adminName,
        maxLines: 1,
        decoration: const InputDecoration(
          hintText: "Ad Soyad",
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Row checkBox() {
    return Row(
      children: [
        Container(
          width: widget.phoneWidth * 0.05,
          margin: EdgeInsets.only(right: widget.phoneWidth * 0.02),
          child: Checkbox(
            activeColor: Colors.blue,
            checkColor: Colors.white,
            value: confBtnisChecked,
            onChanged: (bool? value) {
              setState(() {
                confBtnisChecked = value!;
              });
            },
          ),
        ),
        const Text(
          "Aktife alma işlemini onaylıyorum",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Container pasifeAlButton() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: widget.phoneHeight * 0.01),
      child: ElevatedButton(
          onPressed: () async {
            if (!confBtnisChecked && adminName.text.isEmpty) {
              setState(() {
                _error = "Lütfen geçerli alanları doldurun!";
              });
              return;
            }
            if (confBtnisChecked) {
              if (await makeFoodActive(dropdownActiveValue, adminName.text) == 1) {
                await printTableLogs();
                setState(() {
                  dropDownActiveItems = dropDownActiveItems;
                });
                firstTime = true;
                await addActiveList();
                await loadDataFromDB();
              } else {
                setState(() {
                  _error = "Lütfen yönetici adını doğru şekilde girin!";
                });
              }
            } else {
              setState(() {
                _error = "Lütfen pasife alma işlemini onaylayın!";
              });
            }
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
          child: const Text("Aktife Al", style: TextStyle(fontSize: 25))),
    );
  }

  Container dropDownPassiveMenu() {
    return Container(
      margin: EdgeInsets.only(top: widget.phoneHeight * 0.01, bottom: widget.phoneHeight * 0.02),
      width: widget.phoneWidth * 0.94,
      height: widget.phoneHeight * 0.05,
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.blue.shade200)),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            dropdownColor: Colors.blue[50],
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 30,
            ),
            borderRadius: BorderRadius.circular(20),
            value: dropdownActiveValue,
            onChanged: (String? value) {
              setState(() {
                dropdownActiveValue = value!;
              });
            },
            style: const TextStyle(color: Colors.black),
            selectedItemBuilder: (BuildContext context) {
              return dropDownActiveItems.map((String value) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dropdownActiveValue,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList();
            },
            items: dropDownActiveItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
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

List<String> dropDownActiveItems = [];
