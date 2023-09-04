import 'package:flutter/material.dart';
import 'package:quanto/menu/guillotine_menu.dart';
import 'package:quanto/pages/marcar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Marcar extends StatefulWidget {
  const Marcar({Key? key}) : super(key: key);

  @override
  _MarcarState createState() => _MarcarState();
}

class _MarcarState extends State<Marcar> {
  @override
  void initState() {
    _getTitle();
    super.initState();
  }

  _getTitle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('menu_title', 'Guardar informação');
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
          const MarcarPage(),
          const GuillotineMenu(),
        ],
      ),
    );
  }
}
