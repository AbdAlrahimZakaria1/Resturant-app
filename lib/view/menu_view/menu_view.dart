import 'package:flutter/material.dart';
import 'package:odev/data/menu.dart';

class MenuView extends StatefulWidget {
  final double phoneWidth, phoneHeight;
  const MenuView(this.phoneWidth, this.phoneHeight, {Key? key})
      : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MENU"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: widget.phoneHeight * 0.03, left: widget.phoneWidth * 0.03),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Aşağıdaki alana masa numaranızı giriniz:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            selectingTable(),
            Expanded(
              child: ListView(physics: BouncingScrollPhysics(), children: [
                corbaListView(),
                salataListView(),
                zeytinListView(),
                araListView(),
                anaListView(),
                iceceklerListView(),
                tatlilarListView(),
              ]),
            ),
          ]),
        ));
  }

  Column corbaListView() {
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          child: const Text("Çorbalar:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView(physics: BouncingScrollPhysics(), shrinkWrap: true, children: [
        listView(0, corba),
        listView(1, corba),
        listView(2, corba),
      ]),
    ]);
  }

  Column salataListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(
              top: widget.phoneHeight * 0.03,
              bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Salatalar:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView(shrinkWrap: true, physics: BouncingScrollPhysics(), children: [
        listView(0, salata),
        listView(1, salata),
      ]),
    ]);
  }

  Column zeytinListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(
              top: widget.phoneHeight * 0.03,
              bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Zeytinyağlılar:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView(physics: BouncingScrollPhysics(), shrinkWrap: true, children: [
        listView(0, zeytin),
        listView(1, zeytin),
        listView(2, zeytin),
      ]),
    ]);
  }

  Column araListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(
              top: widget.phoneHeight * 0.03,
              bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Ara Sıcaklar:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView(physics: BouncingScrollPhysics(), shrinkWrap: true, children: [
        listView(0, ara),
        listView(1, ara),
        listView(2, ara),
        listView(3, ara),
        listView(4, ara),
      ]),
    ]);
  }

  Column anaListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(
              top: widget.phoneHeight * 0.03,
              bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Ana Yemekler:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView(physics: BouncingScrollPhysics(), shrinkWrap: true, children: [
        listView(0, ana),
        listView(1, ana),
        listView(2, ana),
        listView(3, ana),
        listView(4, ana),
        listView(5, ana),
        listView(6, ana),
      ]),
    ]);
  }

  Column iceceklerListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(
              top: widget.phoneHeight * 0.03,
              bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("İçecekler:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView(physics: BouncingScrollPhysics(), shrinkWrap: true, children: [
        listView(0, icecekler),
        listView(1, icecekler),
        listView(2, icecekler),
        listView(3, icecekler),
        listView(4, icecekler),
        listView(5, icecekler),
      ]),
    ]);
  }

  Column tatlilarListView() {
    return Column(children: [
      Container(
          margin: EdgeInsets.only(
              top: widget.phoneHeight * 0.03,
              bottom: widget.phoneHeight * 0.01),
          alignment: Alignment.centerLeft,
          child: const Text("Tatlılar:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ListView(physics: BouncingScrollPhysics(), shrinkWrap: true, children: [
        listView(0, tatlilar),
        listView(1, tatlilar),
        listView(2, tatlilar),
        listView(3, tatlilar),
      ]),
    ]);
  }

  Column listView(int index, List type) {
    Yemekler y = type[index];
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(y.foodName,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text("${y.foodPrice} TL", style: const TextStyle(fontSize: 20)),
              ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blue.shade200)),
              width: widget.phoneWidth * 0.1,
              height: widget.phoneHeight * 0.04,
              alignment: Alignment.center,
              child: const Text("0",
                 style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: widget.phoneWidth * 0.03,
                  left: widget.phoneWidth * 0.03),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Ekle", style: TextStyle(fontSize: 20))),
            ),
          ])
        ],
      ),
    ]);
  }

  Padding selectingTable() {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.phoneHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Text(
              "Masa -",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: widget.phoneHeight * 0.04,
              width: widget.phoneWidth * 0.2,
              child: const TextField(
                maxLines: 1,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
              ),
            ),
          ]),
          Padding(
            padding: EdgeInsets.only(right: widget.phoneWidth * 0.03),
            child: ElevatedButton(
                onPressed: () {},
                child: const Text("Otur", style: TextStyle(fontSize: 20))),
          )
        ],
      ),
    );
  }
}
