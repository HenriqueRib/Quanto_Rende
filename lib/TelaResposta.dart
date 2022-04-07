// ignore_for_file: file_names, unused_element

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TelaResposta extends StatefulWidget {
  // const TelaResposta({Key? key}) : super(key: key);
  String valor;

  TelaResposta({Key? key, required this.valor}) : super(key: key);

  @override
  _TelaRespostaState createState() => _TelaRespostaState();
}

class _TelaRespostaState extends State<TelaResposta> {
  _limpar() {
    setState(() {
      // ignore: unused_local_variable
      String _controllerkmFinal = '';
      // ignore: unused_local_variable
      String _controllerkmInicial = "";
      // ignore: unused_local_variable
      String _controllerQtdCombustivel = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quanto meu carro está rendendo'),
          backgroundColor: Colors.indigo,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Image.asset("images/carro-azul.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.valor,
                  style: const TextStyle(
                      fontSize: 50,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }
}
