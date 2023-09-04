import 'package:flutter/material.dart';
import 'package:quanto/menu/guillotine_menu.dart';
import 'package:quanto/pages/visualizar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Visualizar extends StatefulWidget {
  const Visualizar({Key? key}) : super(key: key);

  @override
  _VisualizarState createState() => _VisualizarState();
}

class _VisualizarState extends State<Visualizar> {
  @override
  void initState() {
    _getTitle();
    super.initState();
  }

  _getTitle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('menu_title', 'Visualizar');
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
          const VisualizarPage(),
          const GuillotineMenu(),
        ],
      ),
    );
  }
}
