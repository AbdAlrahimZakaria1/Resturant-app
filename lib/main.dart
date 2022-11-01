import 'package:flutter/material.dart';
import 'package:odev/view/menu_view/menu_view.dart';
import 'package:odev/view_model/bottom_nav_bar/bottom_nav_bar_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
        '/':(context) => const Values(),
        },
    );
  }
}
class Values extends StatelessWidget {
  const Values({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;
    final double phoneHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/menu',
      routes: {
        '/':(context) => MainBottomNavBar(phoneWidth, phoneHeight, 0),
      },
    );
  }
}
