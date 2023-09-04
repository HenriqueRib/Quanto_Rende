import 'package:flutter/material.dart';
import 'package:quanto/menu/guillotine_menu.dart';
import 'package:quanto/pages/perfil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  void initState() {
    _getTitle();
    super.initState();
  }

  _getTitle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('menu_title', 'Perfil');
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
          const PerfilPage(),
          const GuillotineMenu(),
        ],
      ),
    );
  }
}
