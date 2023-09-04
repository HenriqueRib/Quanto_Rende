import 'package:flutter/material.dart';
import 'package:quanto/pages/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'guillotine_menu.dart';

class Guillotine extends StatefulWidget {
  const Guillotine({Key? key}) : super(key: key);

  @override
  _GuillotineState createState() => _GuillotineState();
}

class _GuillotineState extends State<Guillotine> {
  @override
  void initState() {
    _getTitle();
    super.initState();
  }

  _getTitle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('menu_title', 'Quanto Rendes');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        alignment: Alignment.topLeft,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          const Menu(),
          const GuillotineMenu(),
        ],
      ),
    );
  }
}
