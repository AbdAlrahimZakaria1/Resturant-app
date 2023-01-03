import 'package:flutter/material.dart';
import 'package:odev/DB/sqlDB.dart';
import 'package:odev/view/menu_view/menu_view.dart';
import '../../data/menu.dart';
import '../yemek_aktife_al_view/yemek_aktife_al_view.dart';

class YemekPasifeAlView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const YemekPasifeAlView(this.phoneWidth, this.phoneHeight, {Key? key}) : super(key: key);

  @override
  State<YemekPasifeAlView> createState() => _YemekPasifeAlViewState();
}

String dropdownPassiveValue = '';
bool firstTime = true;
bool noActive = false;

List<String> adminNames = ['Emre Güler', 'Abd Alrahim', 'Yüsra Kaplan'];

Future<int> addPassiveList() async {
  dropDownPassiveItems = [];
  List<Map> foodList = await sqlDB.readData("SELECT * FROM $FOOD_MENU WHERE availability = 1");
  if (foodList.isEmpty) {
    noActive = true;
    return 0;
  }
  noActive = false;
  for (int i = 0; i < foodList.length; i++) {
    if (foodList[i]['availability'] == 1) {
      dropDownPassiveItems.add(foodList[i]['food_name']);
    }
  }
  if (firstTime) {
    dropdownPassiveValue = dropDownPassiveItems[0];
    firstTime = false;
  }
  if(dropDownPassiveItems.isEmpty){
    noActive = true;
  }
  return 0;
}

Future<int> makeFoodPassive(foodName, adminName) async {
  for (int i = 0; i < adminNames.length; i++) {
    if (adminName == adminNames[i]) {
      await sqlDB.updateData("UPDATE $FOOD_MENU SET 'availability' = 0 WHERE food_name = '$foodName'");
      await addPassiveList();
      await addActiveList();
      return 1;
    }
  }
  return 0;
}

class _YemekPasifeAlViewState extends State<YemekPasifeAlView> {
  bool confBtnisChecked = false;
  TextEditingController adminName = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YEMEK PASİFE AL"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: widget.phoneHeight * 0.2, left: widget.phoneWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pasife alınacak yemeğin adını girin:",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            dropDownPassiveMenu(),
            const Text(
              "Yemek Pasife Alacak Yönetici",
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
          "Pasife alma işlemini onaylıyorum",
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
            await addActiveList();
            await addPassiveList();
            if(noActive){
              setState(() {
                _error = "Lütfen bir yemek seçin!";
              });
              return;
            }
            if (!confBtnisChecked && adminName.text.isEmpty) {
              setState(() {
                _error = "Lütfen geçerli alanları doldurun!";
              });
              return;
            }
            if (confBtnisChecked) {
              if (await makeFoodPassive(dropdownPassiveValue, adminName.text) == 1) {
                await printTableLogs();
                setState(() {
                  dropDownPassiveItems = dropDownPassiveItems;
                });
                firstTime = true;
                await addPassiveList();
                await addActiveList();
                await loadDataFromDB();
                setState(() {
                  _error = "";
                });
                return;
              } else {
                setState(() {
                  _error = "Lütfen yönetici adını doğru şekilde girin!";
                });
                return;
              }
            }
            if (!confBtnisChecked) {
              setState(() {
                _error = "Lütfen pasife alma işlemini onaylayın!";
              });
              return;
            }
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
          child: const Text("Pasife Al", style: TextStyle(fontSize: 25))),
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
            value: dropdownPassiveValue,
            onChanged: (String? value) {
              setState(() {
                dropdownPassiveValue = value!;
              });
            },
            style: const TextStyle(color: Colors.black),
            selectedItemBuilder: (BuildContext context) {
              return dropDownPassiveItems.map((String value) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dropdownPassiveValue,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList();
            },
            items: dropDownPassiveItems.map<DropdownMenuItem<String>>((String value) {
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

List<String> dropDownPassiveItems = [];
