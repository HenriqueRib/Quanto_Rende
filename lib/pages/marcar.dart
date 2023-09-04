// ignore_for_file: deprecated_member_use, avoid_print
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quanto/util/snac_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dio_config.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class MarcarPage extends StatefulWidget {
  const MarcarPage({Key? key}) : super(key: key);

  @override
  _MarcarPageState createState() => _MarcarPageState();
}

class _MarcarPageState extends State<MarcarPage> {
  final TextEditingController _controllerkmAtual = TextEditingController();
  final TextEditingController _controllerValorLitro =
      MoneyMaskedTextController(decimalSeparator: '.');
  final TextEditingController _controllerValorReais =
      MoneyMaskedTextController(decimalSeparator: '.');
  final TextEditingController _controllerQtdLitrosAbastecido =
      MoneyMaskedTextController(decimalSeparator: '.');
  final TextEditingController _controllerPosto = TextEditingController();
  final FocusNode _focusKmAtual = FocusNode();
  final FocusNode _focusValorLitro = FocusNode();
  final FocusNode _focusValorReais = FocusNode();
  // final FocusNode _focusQtdLitro = FocusNode();
  final FocusNode _focusPosto = FocusNode();
  String dropdownValue = 'Etanol';
  String _textoResultado = "Registre seu abastecimento";

  void _salvarAbastecimento() async {
    final prefs = await SharedPreferences.getInstance();
    EasyLoading.show(status: 'Carregando...');

    try {
      final String? _email = prefs.getString('email'); // Recuperar
      final int? _id = prefs.getInt('id'); // Recuperar

      if (_email == null && _id == null) {
        setState(() {
          _textoResultado =
              "Acredite se quiser ... voce não esta logado. \nFaça o Login por gentileza para salvar.";
        });
        Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
        return;
      }

      if (_controllerkmAtual.text.toString().contains(",") ||
          _controllerValorLitro.text.contains(",") ||
          _controllerValorReais.text.contains(",") ||
          _controllerQtdLitrosAbastecido.text.contains(",")) {
        setState(() {
          _textoResultado =
              "Algo de errado não esta certo ...\nSubistua Vírgula , por ponto .";
        });
        Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
        return;
      }

      FormData data = FormData.fromMap({
        'km_atual': _controllerkmAtual.text,
        'valor_litro': _controllerValorLitro.text,
        'valor_reais': _controllerValorReais.text,
        'qtd_litro_abastecido': _controllerQtdLitrosAbastecido.text,
        'posto': _controllerPosto.text,
        'tipo_combustivel': dropdownValue,
        'email_user': _email,
        'id_user': _id,
      });

      Response res = await dioInstance()
          .post("/quanto_rendes/registrar_abastecimento", data: data);
      if (res.data['status'] == 'success') {
        SnacCustom.success(
            title: "Legal",
            message: "Suas informações foram salvas com Sucesso");
        _limpar();
        Navigator.pushReplacementNamed(context, "/tela_principal");
        setState(() {
          _textoResultado = "Informações Salva com Sucesso";
        });
        Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
      }
    } catch (e) {
      String message = "Erro! Tente novamente mais tarde.";
      if (e is DioError) {
        if (e.response?.data['message'] != null) {
          print('Ok ${e.response}');
          message = e.response?.data['message'];
        }
      }
      print('ERRO $e');
      setState(() {
        _textoResultado = message;
      });
      Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
    }
  }

  _limpar() {
    setState(() {
      _textoResultado = "Registre seu abastecimento";
      _controllerkmAtual.clear();
      _controllerValorLitro.clear();
      _controllerValorReais.clear();
      _controllerQtdLitrosAbastecido.clear();
      _controllerPosto.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _focusKmAtual.unfocus();
        _focusValorLitro.unfocus();
        _focusValorReais.unfocus();
        // _focusQtdLitro.unfocus();
        _focusPosto.unfocus();
      },
      child: Scaffold(
        body: Container(
          color: Colors.teal[900],
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 90,
                    ),
                    child: Text(
                      _textoResultado,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    focusNode: _focusKmAtual,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Km Atual, ex: 118877.5",
                      suffixIcon: IconButton(
                        onPressed: () => _controllerkmAtual.clear(),
                        icon: const Icon(
                          Icons.clear,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 19),
                    controller: _controllerkmAtual,
                  ),
                  TextField(
                    focusNode: _focusValorLitro,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Valor do Litro, ex: 5.14",
                      suffixIcon: IconButton(
                        onPressed: () => _controllerValorLitro.clear(),
                        icon: const Icon(
                          Icons.clear,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                    controller: _controllerValorLitro,
                  ),
                  TextField(
                    focusNode: _focusValorReais,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Valor em reais, ex: 209.09",
                      suffixIcon: IconButton(
                        onPressed: () => _controllerValorReais.clear(),
                        icon: const Icon(
                          Icons.clear,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                    controller: _controllerValorReais,
                  ),
                  // TextField(
                  //   focusNode: _focusQtdLitro,
                  //   keyboardType: TextInputType.number,
                  //   decoration: InputDecoration(
                  //     labelText: "Qtd em litros abastecido, ex: 40.61",
                  //     suffixIcon: IconButton(
                  //       onPressed: () => _controllerQtdLitrosAbastecido.clear(),
                  //       icon: const Icon(
                  //         Icons.clear,
                  //       ),
                  //     ),
                  //   ),
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 19,
                  //   ),
                  //   controller: _controllerQtdLitrosAbastecido,
                  // ),
                  TextField(
                    focusNode: _focusPosto,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Posto de combustível",
                      suffixIcon: IconButton(
                        onPressed: () => _controllerPosto.clear(),
                        icon: const Icon(
                          Icons.clear,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                    controller: _controllerPosto,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 5,
                      right: 5,
                      bottom: 15,
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      elevation: 16,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.teal,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Etanol', 'Gasolina']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton(
                        color: Colors.teal,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                          "Limpar info",
                          style: TextStyle(fontSize: 20),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () => _limpar(),
                      ),
                      FlatButton(
                        color: Colors.teal,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                          "Salvar",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          _salvarAbastecimento();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
