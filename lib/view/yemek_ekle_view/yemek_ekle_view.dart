import 'package:flutter/material.dart';
import 'package:odev/data/menu.dart';
import 'package:odev/view/menu_view/menu_view.dart';
import '../../DB/sqlDB.dart';
import '../yemek_pasife_al_view/yemek_pasife_al_view.dart';
import 'package:validators/validators.dart';

class YemekEkleView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const YemekEkleView(this.phoneWidth, this.phoneHeight, {Key? key}) : super(key: key);

  @override
  State<YemekEkleView> createState() => _YemekEkleViewState();
}

Future<int> addFood(foodName, foodPrice, foodType) async {
  int insertResponse = await sqlDB.insertData("INSERT INTO 'foodMenu1' "
      "('name', 'price', 'type', 'availability', 'manager_id', 'food_quantity') "
      "VALUES ('$foodName', '$foodPrice', '$foodType', '1' , 101, 0)");
  return 0;
}

bool foodNameCheck(String str) {
  List stringList = str.split(' ');
  for (int i = 0; i < stringList.length; i++) {
    if (stringList[i] == null || stringList[i].isEmpty || !isUppercase(stringList[i][0])) {
      return false;
    }
  }
  return true;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

class _YemekEkleViewState extends State<YemekEkleView> {
  TextEditingController foodName = new TextEditingController();
  TextEditingController foodPrice = new TextEditingController();
  SqlDB sqlDB = SqlDB();
  String dropdownValue = 'Çorba';
  bool confBtnIsChecked = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("YEMEK EKLE"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: widget.phoneHeight * 0.2, left: widget.phoneWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Eklenecek yemeğin kategorisi",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            dropDownMenu(),
            const Text(
              "Eklenecek yemeğin adını girin:",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            yemekAdiTextField(),
            const Text(
              "Yemeğin Fiyatı",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            yemekFiyat(),
            checkBox(),
            yemekEkleButton(),
            errorBox()
          ],
        ),
      ),
    );
  }

  Container dropDownMenu() {
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
            value: dropdownValue,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            style: const TextStyle(color: Colors.black),
            selectedItemBuilder: (BuildContext context) {
              return dropDownMenuItems.map((String value) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dropdownValue,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList();
            },
            items: dropDownMenuItems.map<DropdownMenuItem<String>>((String value) {
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

  Container yemekAdiTextField() {
    return Container(
      margin: EdgeInsets.only(top: widget.phoneHeight * 0.01, bottom: widget.phoneHeight * 0.02),
      height: widget.phoneHeight * 0.05,
      width: widget.phoneWidth * 0.94,
      child: TextField(
        maxLines: 1,
        controller: foodName,
        decoration: const InputDecoration(
          hintText: "Bir yemek adı girin",
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Container yemekFiyat() {
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
          hintText: "",
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
            value: confBtnIsChecked,
            onChanged: (bool? value) {
              setState(() {
                confBtnIsChecked = value!;
              });
            },
          ),
        ),
        const Text(
          "Yemek ekleme işlemini onaylıyorum",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Container yemekEkleButton() {
    return Container(
      padding: EdgeInsets.only(top: widget.phoneHeight * 0.01),
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
          onPressed: () async {
            if(!confBtnIsChecked && foodName.text.isEmpty && foodPrice.text.isEmpty){
              setState(() {
                _error = "Lütfen geçerli alanları doldurun!";
              });
              return;
            }
            if (!foodNameCheck(foodName.text)){
              setState(() {
                _error = "Lütfen eklenecek yemek adını doğru girin!";
              });
            return;
            }
            if(foodName.text.isNotEmpty && foodName.text.length > 20){
              setState(() {
                _error = "Lütfen daha kısa bir yemek adı girin!";
              });
              return;
            }
            if(foodPrice.text.isEmpty){
              setState(() {
                _error = "Lütfen yemek fiyatını girin!";
              });
              return;
            }
            if(!isNumeric(foodPrice.text)){
              setState(() {
                _error = "Lütfen geçerli bir karakter girin!";
              });
              return;
            }
            if(double.parse(foodPrice.text) < 0){
              setState(() {
                _error = "Lütfen yemek fiyatını pozitif sayı olarak girin!";
              });
              return;
            }
            if(foodPrice.text.length > 6){
              setState(() {
                _error = "Lütfen 6 karakterden fazla girmeyin!";
              });
              return;
            }
            if(!confBtnIsChecked){
              setState(() {
                _error = "Lütfen yemek ekleme işlemini onaylayın!";
              });
              return;
            }
            setState(() {
              _error = "";
            });
            await addFood(foodName.text, double.parse(foodPrice.text), dropdownValue);
            await loadDataFromDB();
            await printTableLogs();
            await addPassiveList();
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
          child: const Text("Yemek Ekle", style: TextStyle(fontSize: 25))),
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

List<String> dropDownMenuItems = ['Çorba', 'Salata', 'Zeytinyağlı', 'Ara Sıcak', 'Ana Yemek', 'İçecek', 'Tatlı'];
