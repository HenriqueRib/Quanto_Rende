import 'package:flutter/material.dart';
import 'package:quanto/menu/guillotine_menu.dart';
import 'package:quanto/pages/configuracao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({Key? key}) : super(key: key);

  @override
  _ConfiguracaoState createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  @override
  void initState() {
    _getTitle();
    super.initState();
  }

  _getTitle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('menu_title', 'Configuração');
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
          const ConfiguracaoPage(),
          const GuillotineMenu(),
        ],
      ),
    );
  }
}
