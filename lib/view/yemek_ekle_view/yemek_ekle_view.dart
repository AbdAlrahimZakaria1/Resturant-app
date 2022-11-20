import 'package:flutter/material.dart';
import 'package:odev/data/menu.dart';

class YemekEkleView extends StatefulWidget {
  final double phoneWidth, phoneHeight;

  const YemekEkleView(this.phoneWidth, this.phoneHeight, {Key? key})
      : super(key: key);

  @override
  State<YemekEkleView> createState() => _YemekEkleViewState();
}

class _YemekEkleViewState extends State<YemekEkleView> {
  TextEditingController foodName = new TextEditingController();
  TextEditingController foodPrice = new TextEditingController();

  String dropdownValue = 'Çorba';
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("YEMEK EKLE"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: widget.phoneHeight * 0.2, left: widget.phoneWidth * 0.03),
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
          ],
        ),
      ),
    );
  }

  Container dropDownMenu() {
    return Container(
      margin: EdgeInsets.only(
          top: widget.phoneHeight * 0.01, bottom: widget.phoneHeight * 0.02),
      width: widget.phoneWidth * 0.94,
      height: widget.phoneHeight * 0.05,
      decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.blue.shade200)),
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
            items:
                dropDownMenuItems.map<DropdownMenuItem<String>>((String value) {
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
      margin: EdgeInsets.only(
          top: widget.phoneHeight * 0.01, bottom: widget.phoneHeight * 0.02),
      height: widget.phoneHeight * 0.05,
      width: widget.phoneWidth * 0.94,
      child: TextField(
        maxLines: 1,
        controller: foodName,
        decoration: const InputDecoration(
          hintText: "Bir yemek adı girin",
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
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
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
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
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
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
          onPressed: () => addFood(),
          style: ElevatedButton.styleFrom(
              fixedSize:
                  Size(widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
          child: const Text("Yemek Ekle", style: TextStyle(fontSize: 25))),
    );
  }

  void addFood() {
    if (dropdownValue == "Çorba") {
      corba.add(Yemekler("Çorba", foodName.text, double.parse(foodPrice.text)));
    } else if (dropdownValue == 'Salata') {
      salata
          .add(Yemekler('Salata', foodName.text, double.parse(foodPrice.text)));
    } else if (dropdownValue == 'Zeytinyağlı') {
      zeytin.add(Yemekler(
          'Zeytinyağlılar', foodName.text, double.parse(foodPrice.text)));
    } else if (dropdownValue == 'Ara Sıcak') {
      ara.add(Yemekler(
          'Ara Sıcaklar', foodName.text, double.parse(foodPrice.text)));
    } else if (dropdownValue == 'Ana Yemek') {
      ana.add(Yemekler(
          'Ana Yemekler', foodName.text, double.parse(foodPrice.text)));
    } else if (dropdownValue == 'İçecek') {
      icecekler.add(
          Yemekler('İçecekler', foodName.text, double.parse(foodPrice.text)));
    } else if (dropdownValue == 'Tatlı') {
      tatlilar.add(
          Yemekler('Tatlılar', foodName.text, double.parse(foodPrice.text)));
    }
  }
}

List<String> dropDownMenuItems = [
  'Çorba',
  'Salata',
  'Zeytinyağlı',
  'Ara Sıcak',
  'Ana Yemek',
  'İçecek',
  'Tatlı'
];
