// ignore_for_file: must_be_immutable, unused_element, unused_field, unused_local_variable

import 'package:flutter/material.dart';

class TelaResposta extends StatefulWidget {
  // const TelaResposta({Key? key}) : super(key: key);
  String valor;

  TelaResposta({required this.valor});

  @override
  _TelaRespostaState createState() => _TelaRespostaState();
}

class _TelaRespostaState extends State<TelaResposta> {
  TextEditingController _controllerkmFinal = TextEditingController();
  TextEditingController _controllerkmInicial = TextEditingController();
  TextEditingController _controllerQtdCombustivel = TextEditingController();
  String _textoResultado = "Descubra quanto que seu carro está rendendo";

  _calcularkm() {
    int kmfinal = int.parse(_controllerkmFinal.text);
    int kminicial = int.parse(_controllerkmInicial.text);
    double qtdCombustivel = double.parse(_controllerQtdCombustivel.text);
    int resultado;
    double _kmPorLitro;

    resultado = kmfinal - kminicial;
    setState(() {
      _kmPorLitro = resultado / qtdCombustivel;
      _textoResultado = " Desta vez seu carro fez " +
          _kmPorLitro.toStringAsFixed(
              _kmPorLitro.truncateToDouble() == _kmPorLitro ? 0 : 2) +
          "km por Combustível!";
    });
  }

  _limpar() {
    setState(() async {
      _textoResultado = "Descubra quanto que seu carro está rendendo";
      String _controllerkmFinal = '';
      String _controllerkmInicial = "";
      String _controllerQtdCombustivel = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quanto meu carro está rendendo'),
          backgroundColor: Colors.indigo,
        ),
        body: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Image.asset("images/carro-azul.png"),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "${widget.valor}",
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
