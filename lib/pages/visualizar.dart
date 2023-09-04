// ignore_for_file: avoid_print, deprecated_member_use, unused_label
import 'dart:async';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:quanto/dio_config.dart';
import 'package:quanto/util/snac_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisualizarPage extends StatefulWidget {
  const VisualizarPage({Key? key}) : super(key: key);

  @override
  _VisualizarPageState createState() => _VisualizarPageState();
}

class _VisualizarPageState extends State<VisualizarPage> {
  get onPressed => null;

  @override
  void initState() {
    _getAbastecimento();
    _verificaConexao();
    super.initState();
  }

  late List _itens = [];
  void _getAbastecimento() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final String? _email = prefs.getString('email');
      final int? _id = prefs.getInt('id');
      FormData data = FormData.fromMap({'email': _email, 'id': _id});
      Response res =
          await dioInstance().post("/quanto_rendes/visualizar", data: data);

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

  void deleteRegistro(id) async {
    try {
      FormData data = FormData.fromMap({
        'id': id,
      });

      Response res = await dioInstance()
          .post("/quanto_rendes/delete_registro", data: data);
      if (res.data['status'] == 'success') {
        // print(res.data);
        _getAbastecimento();
        SnacCustom.success(
          title: "Legal",
          message: "Sua informações foi deletada com Sucesso",
        );
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response);
      }
      print('ERRO $e');
    }
  }

  void deletarInfo(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Deseja mesmo deletar essa informação?"),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text("Deletar"),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                deleteRegistro(id);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _editarInfo(BuildContext context, registro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id_editar', registro['id']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text("Você deseja Editar este registro de abastecimento"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: const Text("Não"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: const Text("Sim"),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/editar");
                  },
                )
              ],
            ),
          ],
        );
      },
    );
  }

  _verificaConexao() async {
    EasyLoading.show(status: 'Verificando Conexão...');
    if (await ConnectivityWrapper.instance.isConnected) {
      // print("Conectado");
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError('Verifique sua conexão com a internet');
      Navigator.pushReplacementNamed(context, "/menu");
      Timer(const Duration(seconds: 20), () => EasyLoading.dismiss());
      // print("DesConectado");
    }
  }

  Future<void> _refresh() async {
    EasyLoading.show(status: 'Carregando...');
    if (await ConnectivityWrapper.instance.isConnected) {
      // print("Conectado");
      _getAbastecimento();
    } else {
      // print("DesConectado");
      EasyLoading.dismiss();
      EasyLoading.showError('Verifique sua conexão com a internet');
      Navigator.pushReplacementNamed(context, "/menu");
      Timer(const Duration(seconds: 50), () => EasyLoading.dismiss());
    }
    EasyLoading.dismiss();
    // return Future.delayed(const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        displacement: 100,
        child: Container(
          color: Colors.teal[900],
          height: MediaQuery.of(context).size.height * 1,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 60),
            itemCount: _itens.length,
            itemBuilder: (context, indice) {
              Map<String, dynamic> item = _itens[indice];
              double _valorLitro = item["valor_litro"].toDouble();
              int _id = item["id"];
              int _kmAtual = item["km_atual"];
              double _valorReais = item["valor_reais"].toDouble();
              double _valorPorLitro = item["valorPorLitro"].toDouble();
              double _qtdLitro = item["qtd_litro_abastecido"].toDouble();
              String _tipoCombustivel = item["tipo_combustivel"];
              String _data = item["data"];
              DateTime dt = DateTime.parse(_data);
              _data = DateFormat("d/MM/yyyy HH:mm:ss").format(dt);
              // print(item);
              String _kmRodados = item["km_rodados"] == 0
                  ? 'Não Contabilizado'
                  : item["km_rodados"].toString();

              return Slidable(
                key: const ValueKey(0),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  // dismissible: DismissiblePane(onDismissed: () {
                  //   deletarInfo(context, _id);
                  // }),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        deletarInfo(context, _id);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        _editarInfo(context, _itens[indice]);
                      },
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Editar',
                    ),
                  ],
                ),
                child: Card(
                  color: const Color.fromARGB(34, 67, 117, 61),
                  elevation: 5,
                  margin: EdgeInsets.all(5.sp),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(5.sp),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data Registro : $_data",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.sp),
                        Text(
                          "KM Atual: $_kmAtual",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "KM Rodados: $_kmRodados",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "KM por Quantidade de Litro: ${_valorPorLitro.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "Quantidade de Litros: $_qtdLitro",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "Valor: R\$$_valorReais",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.sp),
                        Text(
                          "Detalhes do Abastecimento",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Tipo de Combustível: $_tipoCombustivel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "Litros: $_valorLitro",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "Data: $_data",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void doNothing(BuildContext context) {}
