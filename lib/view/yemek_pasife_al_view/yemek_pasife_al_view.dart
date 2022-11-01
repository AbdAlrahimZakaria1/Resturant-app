import 'package:flutter/material.dart';

class YemekPasifeAlView extends StatefulWidget {
  final double phoneWidth, phoneHeight;
  const YemekPasifeAlView(this.phoneWidth, this.phoneHeight, {Key? key})
      : super(key: key);

  @override
  State<YemekPasifeAlView> createState() => _YemekPasifeAlViewState();
}

class _YemekPasifeAlViewState extends State<YemekPasifeAlView> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YEMEK PASİFE AL"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
            top: widget.phoneHeight * 0.2, left: widget.phoneWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pasife alınacak yemeğin adını girin:",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              araTextField(),
              araButton(),
            ]),
            const Text(
              "Yemek Pasife Alacak Yönetici",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            adSoyadTextField(),
            checkBox(),
            pasifeAlButton(),
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
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Container araButton() {
    return Container(
      margin: EdgeInsets.only(
          top: widget.phoneHeight * 0.01,
          bottom: widget.phoneHeight * 0.02,
          left: widget.phoneWidth * 0.032),
      height: widget.phoneHeight * 0.06,
      child: ElevatedButton(
          onPressed: () {},
          child: const Text("Ara", style: TextStyle(fontSize: 20))),
    );
  }

  Container adSoyadTextField() {
    return Container(
      margin: EdgeInsets.only(top: widget.phoneHeight * 0.01),
      height: widget.phoneHeight * 0.06,
      width: widget.phoneWidth * 0.94,
      child: const TextField(
        maxLines: 1,
        decoration: InputDecoration(
          hintText: "Ad Soyad",
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              fixedSize:
                  Size(widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
          child: const Text("Pasife Al", style: TextStyle(fontSize: 25))),
    );
  }
}
