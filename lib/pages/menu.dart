// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quanto/dio_config.dart';
import 'package:quanto/widgets/menu_card.dart';
// import 'package:quanto/widgets/metric_card.dart';
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
    _getAbastecimento();
    super.initState();
  }

  int _kmAtual = 0;
  double _mesAtual = 0;
  double _somaKmRodadosMes = 0;
  double _somaValorReaisMes = 0;
  double _somaQtdLitroAbastecidoMes = 0;
  double _somaKmRodadosTotal = 0;
  double _somaValorReaisTotal = 0;
  double _somaQtdLitroAbastecidoTotal = 0;
  Map<int, Map<String, double>> infoPorMes = {};

  late List _itens = [];
  void _getAbastecimento() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final String? _email = prefs.getString('email');
      final int? _id = prefs.getInt('id');
      FormData data = FormData.fromMap({'email': _email, 'id': _id});
      Response res =
          await dioInstance().post("/quanto_rendes/visualizar", data: data);
      // Obtenha a data atual para determinar o mês atual
      DateTime dataAtual = DateTime.now();
      int mesAtual = dataAtual.month.toInt();
      _mesAtual = mesAtual.toDouble();
      bool kmAtualbool = true;
      print(res.data);
      for (var mes in infoPorMes.values) {
        mes["somaKmRodadosMes"] = 0.0;
        mes["somaValorReaisMes"] = 0.0;
        mes["somaQtdLitroAbastecidoMes"] = 0.0;
        mes["quantidadeRegistrosMes"] = 0;
      }
      // Iterar pela lista res.data['abastecimento']
      for (var item in res.data['abastecimento']) {
        int kmAtualItem = item["km_atual"];
        String dataItem = item["data"];
        DateTime dataItemParsed = DateTime.parse(dataItem);
        int mesItem = dataItemParsed.month;

        // Verifique se a data pertence ao mês atual
        if (kmAtualbool == true) {
          kmAtualbool = false;
          _kmAtual = kmAtualItem;
        }

        // Crie um mapa para o mês atual com valores iniciais como 0.0
        infoPorMes[mesItem] ??= {
          "numeroMes": mesItem.toDouble(),
          "somaKmRodadosMes": 0.0,
          "somaValorReaisMes": 0.0,
          "somaQtdLitroAbastecidoMes": 0.0,
          "quantidadeRegistrosMes": 0,
        };
        // Incrementar a contagem de registros por mês
        infoPorMes[mesItem]!["quantidadeRegistrosMes"] =
            (infoPorMes[mesItem]!["quantidadeRegistrosMes"] ?? 0) + 1;

        // Converta os valores para double antes de usar +=
        double kmRodados = item["km_rodados"].toDouble();
        double valorReais = item["valor_reais"].toDouble();
        double qtdLitroAbastecido = item["qtd_litro_abastecido"].toDouble();

        // Atribua os valores diretamente
        infoPorMes[mesItem]!["somaKmRodadosMes"] =
            (infoPorMes[mesItem]!["somaKmRodadosMes"] ?? 0.0) + kmRodados;
        infoPorMes[mesItem]!["somaValorReaisMes"] =
            (infoPorMes[mesItem]!["somaValorReaisMes"] ?? 0.0) + valorReais;
        infoPorMes[mesItem]!["somaQtdLitroAbastecidoMes"] =
            (infoPorMes[mesItem]!["somaQtdLitroAbastecidoMes"] ?? 0.0) +
                qtdLitroAbastecido;

        // Atualize as métricas totais
        _somaKmRodadosTotal += kmRodados;
        _somaValorReaisTotal += valorReais;
        _somaQtdLitroAbastecidoTotal += qtdLitroAbastecido;
      }

      print(infoPorMes);
      setState(() {
        _itens = [];
        _itens = res.data['abastecimento'];
      });
    } catch (e) {
      // print('ERRO $e');
      // String message = "Erro! Tente novamente mais tarde.";
      if (e is DioError) {
        if (e.response?.data['message'] != null) {
          print('Erro em carregar registros de abastecimento -> ${e.response}');
          // message = e.response?.data['message'];
        }
      }
    }
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

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
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
                  _getAbastecimento();
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
                                  Container(
                                    padding: EdgeInsets.all(8.sp),
                                    alignment: Alignment.topLeft,
                                    child: Stack(
                                      children: [
                                        Container(
                                          color: Colors.teal[900],
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  1 -
                                              200.sp,
                                          width: double.infinity,
                                          padding: EdgeInsets.only(top: 5.sp),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            itemCount: infoPorMes.length,
                                            itemBuilder: (context, indice) {
                                              int mesNumero = infoPorMes.keys
                                                  .elementAt(indice)
                                                  .toInt();

                                              double? somaKmRodadosMes =
                                                  infoPorMes[mesNumero]![
                                                      'somaKmRodadosMes'];
                                              double?
                                                  somaQtdLitroAbastecidoMes =
                                                  infoPorMes[mesNumero]![
                                                      'somaQtdLitroAbastecidoMes'];

                                              String kmPorLitro =
                                                  (somaKmRodadosMes! /
                                                              somaQtdLitroAbastecidoMes!)
                                                          .toStringAsFixed(2) +
                                                      " km/l";

                                              String nomeMes = DateFormat(
                                                'MMMM',
                                                'pt_BR',
                                              ).format(
                                                  DateTime(2023, mesNumero));
                                              nomeMes = capitalize(nomeMes);
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 3.sp),
                                                padding: EdgeInsets.all(15.sp),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10.sp,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(15.sp),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(
                                                            83, 9, 239, 201),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        "Mês: $nomeMes",
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.sp,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width:
                                                              1.sw / 2 - 30.sp,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.sp),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                    .fromARGB(
                                                                83,
                                                                9,
                                                                239,
                                                                201),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Valor total gasto no mês com combustível: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Text(
                                                                "R\$ ${infoPorMes[mesNumero]!['somaValorReaisMes']!.toStringAsFixed(2)}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      25.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              1.sw / 2 - 25.sp,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.sp),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                    .fromARGB(
                                                                83,
                                                                9,
                                                                239,
                                                                201),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Kilometragem rodados pelo mês :",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Text(
                                                                " ${infoPorMes[mesNumero]!['somaKmRodadosMes']} km",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      25.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.sp,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width:
                                                              1.sw / 2 - 30.sp,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.sp),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                    .fromARGB(
                                                                83,
                                                                9,
                                                                239,
                                                                201),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Média de Kilometragem rodados por Litro: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Text(
                                                                kmPorLitro,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      25.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              1.sw / 2 - 25.sp,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.sp),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                    .fromARGB(
                                                                83,
                                                                9,
                                                                239,
                                                                201),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    "Quantidade de vezes abastecido por mês: ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${infoPorMes[mesNumero]!['quantidadeRegistrosMes']!.toInt()} vezes",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          25.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),

                                          // child: ListView.builder(
                                          //     padding:
                                          //         const EdgeInsets.only(top: 3),
                                          //     itemCount: infoPorMes.length,
                                          //     itemBuilder: (context, indice) {
                                          //       double? somaKmRodadosMes =
                                          //           infoPorMes[mesNumero]![
                                          //               'somaKmRodadosMes'];
                                          //       double?
                                          //           somaQtdLitroAbastecidoMes =
                                          //           infoPorMes[mesNumero]![
                                          //               'somaQtdLitroAbastecidoMes'];

                                          //       String kmPorLitro =
                                          //           (somaKmRodadosMes! /
                                          //                       somaQtdLitroAbastecidoMes!)
                                          //                   .toStringAsFixed(
                                          //                       2) +
                                          //               " km/l";

                                          //       return Container(
                                          //         height: 500,
                                          //         width: 2000,
                                          //         decoration:
                                          //             const BoxDecoration(
                                          //           color: Colors.black54,
                                          //         ),
                                          //         padding:
                                          //             const EdgeInsets.all(20),
                                          //         child: Text(
                                          //           "Informações \n\nSeu Km atual: $_kmAtual   \nValor total gasto no mês com combustível: R\$ ${infoPorMes[mesNumero]!['somaValorReaisMes']} \nMédia de Kilometragem rodados por Litro: $kmPorLitro \nKilometragem rodados pelo mês atual: ${infoPorMes[mesNumero]!['somaKmRodadosMes']} km  \nQuantidade de vezes abastecido por mês:${infoPorMes[mesNumero]!['quantidadeRegistrosMes']!.toInt()} vezes\n\n\n\n",
                                          //           style: TextStyle(
                                          //             fontSize: 20.sp,
                                          //             color: Colors.white,
                                          //           ),
                                          //         ),
                                          //       );
                                          //     }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
