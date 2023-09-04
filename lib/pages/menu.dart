import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quanto/widgets/menu_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  final List<Map> _menus = <Map>[
    {
      "icon": Icons.view_agenda,
      "title": "Visualizar",
      "color": Colors.teal,
      'route': "/visualizar"
    },
    {
      "icon": Icons.edit,
      "title": "Marcar",
      "color": Colors.teal,
      'route': "/marcar"
    },
    {
      "icon": Icons.calculate,
      "title": "Calcular",
      "color": Colors.teal,
      'route': "/aplicacao"
    },
    {
      "icon": Icons.person,
      "title": "Perfil",
      "color": Colors.teal,
      'route': "/perfil"
    },
    // {
    //   "icon": Icons.settings,
    //   "title": "Configuração",
    //   "color": Colors.teal,
    //   'route': "/configuracao"
    // },
    {
      "icon": Icons.login,
      "title": "Sair",
      "color": Colors.teal,
      'route': "/login"
    },
  ];

  String? nome;
  _getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString('nome');
    });
  }

  Future<void> _refresh() async {
    EasyLoading.show(status: 'Carregando Dados...');
    _getInfo();
    Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
    return Future.delayed(
      const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        // displacement: 100,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/background.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 1,
              color: Colors.blue,
            ),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: RefreshIndicator(
                onRefresh: () async {
                  var futures = <Future>[];
                  await Future.wait(futures);
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: SizedBox(
                                      height: 75,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: List.generate(
                                          _menus.length,
                                          (index) {
                                            return MenuCard(
                                              index: index,
                                              menuItem: _menus,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Bem-vindo $nome \n ao Quanto Rendes",
                                      style: const TextStyle(
                                        fontSize: 21,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: const EdgeInsets.all(25),
                                  //   alignment: Alignment.topLeft,
                                  //   child: const Text(
                                  //     "Seu Km atual:  \nValor total gasto no mês:  \nMedia de Kilometragem por Litro:  \nSeu Km atual:  \nSeu Km atual:  \nSeu Km atual:  \n",
                                  //     style: TextStyle(
                                  //       fontSize: 21,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    alignment: Alignment.topLeft,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 500,
                                          width: 2000,
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                          ),
                                          padding: const EdgeInsets.all(20),
                                          child: const Text(
                                            "Informações \n\nSeu Km atual:  \nValor total gasto no mês com combustivel:  \nMedia de Kilometragem rodados por Litro:  \n Kilometragem rodados pelo mês atual:  \n Quantidade de vezes abastecido por mês: \n\n\n\n ",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(20),
                                    // padding: EdgeInsets.only(top: 5),
                                    child: Card(
                                      elevation: 0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      child: const SizedBox(
                                        width: 800,
                                        height: 100,
                                        child: Center(
                                          child: Text(
                                            "Ola",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                  ),
                                  child: const SizedBox(
                                    width: 300,
                                    height: 100,
                                    child: Center(child: Text('Outlined Card')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
