import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  final double phoneWidth, phoneHeight;
  const CartView(this.phoneWidth, this.phoneHeight, {Key? key})
      : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEPET"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: widget.phoneHeight * 0.2, left: widget.phoneWidth * 0.03),
        child: Column(children: [
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 4,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(children: [
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
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
                              Padding(
                                padding: EdgeInsets.only(
                                    right: widget.phoneWidth * 0.03,
                                    left: widget.phoneWidth * 0.03),
                                child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: const Text("Sil",
                                        style: TextStyle(fontSize: 20))),
                              ),
                            ])
                      ]),
                ]);
              }),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: widget.phoneHeight * 0.02),
            child: const Text(
              "Toplam: 0.00TL",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: widget.phoneHeight * 0.01),
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                        widget.phoneWidth * 0.94, widget.phoneHeight * 0.06)),
                child:
                    const Text("Siparis Ver", style: TextStyle(fontSize: 25))),
          )
        ]),
      ),
    );
  }
}
