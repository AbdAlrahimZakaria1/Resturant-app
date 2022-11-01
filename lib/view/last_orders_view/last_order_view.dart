import 'package:flutter/material.dart';

class LastOrderView extends StatefulWidget {
  final double phoneWidth, phoneHeight;
  const LastOrderView(this.phoneWidth, this.phoneHeight, {Key? key})
      : super(key: key);

  @override
  State<LastOrderView> createState() => _LastOrderViewState();
}

class _LastOrderViewState extends State<LastOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      title: Text("GEÇMİŞ"),
      automaticallyImplyLeading: false,
    ),
        body: Padding(
            padding: EdgeInsets.only(
                top: widget.phoneHeight * 0.2),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(left: widget.phoneWidth * 0.02,bottom:widget.phoneHeight * 0.02 ),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Son Siparis:",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: widget.phoneHeight * 0.02),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Colors.blue.shade200)),
                      child: Column(children: [
                        lastOrderDetails(),
                        lastOrderDetails(),
                        lastOrderDetails(),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: widget.phoneHeight * 0.02,left: widget.phoneWidth * 0.02),
                          child: const Text(
                            "Toplam: 0.00TL",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      ]))
                ])));
  }

  ListView lastOrderDetails() {
    return ListView(
        shrinkWrap: true,
        children: [
    Padding(
      padding:EdgeInsets.only(left: widget.phoneWidth * 0.02),
      child: Column(children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Mercimek Çorbası",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("0.00 TL", style: TextStyle(fontSize: 20)),
                ]),
                  Container(
                    margin: EdgeInsets.only(right: widget.phoneWidth*0.03),
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.blue.shade200)),
                    width: widget.phoneWidth * 0.1,
                    height: widget.phoneHeight * 0.04,
                    alignment: Alignment.center,
                    child: const Text("1",
                        style: TextStyle(fontSize: 20)),
                  ),

          ]),
      ]),
    )
    ]);
  }
}
