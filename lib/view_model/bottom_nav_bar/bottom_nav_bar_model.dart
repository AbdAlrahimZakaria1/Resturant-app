import 'package:flutter/material.dart';
import 'package:odev/view/last_orders_view/last_order_view.dart';
import 'package:odev/view/menu_view/menu_view.dart';
import 'package:odev/view/payment_menu/payment_menu_view.dart';
import 'package:odev/view/yemek_pasife_al_view/yemek_pasife_al_view.dart';
import '../../view/cart_view/cart_view.dart';
import '../../view/yemek_aktife_al_view/yemek_aktife_al_view.dart';
import '../../view/yemek_ekle_view/yemek_ekle_view.dart';

class MainBottomNavBar extends StatefulWidget {
  int selectedIndex;
  final double phoneWidth, phoneHeight;

  MainBottomNavBar(this.phoneWidth, this.phoneHeight, this.selectedIndex, {Key? key}) : super(key: key);

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    resizeToAvoidBottomInset: false,
    bottomNavigationBar:BottomNavigationBar(
            elevation: 20,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.shifting,
            unselectedItemColor: Colors.black,
            currentIndex: widget.selectedIndex,
            items: bottomNavList,
            selectedItemColor: Colors.white,
            selectedIconTheme: const IconThemeData(size: 30,color: Colors.white),
            onTap: _onItemTapped,
          ),
        body: pages.elementAt(widget.selectedIndex),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainBottomNavBar(widget.phoneWidth, widget.phoneHeight, index)));
  }

  late List<Widget> pages = [
    MenuView(widget.phoneWidth, widget.phoneHeight),
    CartView(widget.phoneWidth, widget.phoneHeight),
    YemekEkleView(widget.phoneWidth, widget.phoneHeight),
    YemekPasifeAlView(widget.phoneWidth, widget.phoneHeight),
    YemekAktifeAlView(widget.phoneWidth, widget.phoneHeight),
    PaymentMenuView(widget.phoneWidth, widget.phoneHeight),
    LastOrderView(widget.phoneWidth, widget.phoneHeight),
  ];

  List<BottomNavigationBarItem> bottomNavList = [
    bottomNavBarItemsGetter(Icons.menu, "Menu"),
    bottomNavBarItemsGetter(Icons.shopping_cart, "Sepet"),
    bottomNavBarItemsGetter(Icons.fastfood, "Yemek Ekle"),
    bottomNavBarItemsGetter(Icons.no_food, "Yemek Pasife Al"),
    bottomNavBarItemsGetter(Icons.fastfood, "Yemek Aktif Et"),
    bottomNavBarItemsGetter(Icons.fastfood, "Payment"),
    bottomNavBarItemsGetter(Icons.person, "Geçmiş")
  ];
}

BottomNavigationBarItem bottomNavBarItemsGetter(icon, String label) {
  return BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(icon),
      activeIcon: Icon(
        icon,
      ),
      label: label);
}
