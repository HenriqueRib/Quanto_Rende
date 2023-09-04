// ignore_for_file: deprecated_member_use
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:quanto/menu/guillotine.dart';
import 'package:quanto/pages/TelaResposta.dart';

class Aplicacao extends StatefulWidget {
  const Aplicacao({Key? key}) : super(key: key);

  @override
  _AplicacaoState createState() => _AplicacaoState();
}

class _AplicacaoState extends State<Aplicacao> {
  final TextEditingController _controllerkmFinal = TextEditingController();
  final TextEditingController _controllerkmInicial = TextEditingController();
  final TextEditingController _controllerQtdCombustivel =
      MoneyMaskedTextController(decimalSeparator: '.');
  String _textoResultado = "Descubra quanto que seu carro está rendendo";
  final FocusNode _focusKmInicial = FocusNode();
  final FocusNode _focusKmFinal = FocusNode();
  final FocusNode _focusCombustivel = FocusNode();

  _calcularkm() {
    try {
      int kmfinal = int.parse(_controllerkmFinal.text);
      int kminicial = int.parse(_controllerkmInicial.text);
      double qtdCombustivel = double.parse(_controllerQtdCombustivel.text);
      int resultado;
      double _kmPorLitro;

      resultado = kmfinal - kminicial;
      if (resultado > 0 || resultado <= 0) {
        setState(() {
          _kmPorLitro = resultado / qtdCombustivel;
          _textoResultado = "Desta vez seu carro fez " +
              _kmPorLitro.toStringAsFixed(
                  _kmPorLitro.truncateToDouble() == _kmPorLitro ? 0 : 2) +
              "km por Combustível!";
        });
      }
    } catch (_) {
      setState(
        () {
          _textoResultado = "Preencha os campos para calcular";
        },
      );
    }
  }

  _limpar() {
    setState(() {
      _textoResultado = "Descubra quanto que seu carro está rendendo";
      _controllerkmFinal.clear();
      _controllerkmInicial.clear();
      _controllerQtdCombustivel.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _focusKmInicial.unfocus();
        _focusKmFinal.unfocus();
        _focusCombustivel.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quanto meu carro está rendendo'),
          backgroundColor: Colors.teal,
          shadowColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.teal[900],
            height: MediaQuery.of(context).size.height * 1,
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 05),
                  child: Image.asset("assets/img/carro-azul.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _textoResultado,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  focusNode: _focusKmFinal,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Km Final, ex: 73111",
                    suffixIcon: IconButton(
                      onPressed: () => _controllerkmFinal.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 19),
                  controller: _controllerkmFinal,
                ),
                TextField(
                  focusNode: _focusKmInicial,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Km Inicial, ex: 72878",
                    suffixIcon: IconButton(
                      onPressed: () => _controllerkmInicial.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 19),
                  controller: _controllerkmInicial,
                ),
                TextField(
                  focusNode: _focusCombustivel,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Qtd de Combustível, ex: 13.5",
                    suffixIcon: IconButton(
                      onPressed: () => _controllerQtdCombustivel.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 19),
                  controller: _controllerQtdCombustivel,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RaisedButton(
                        color: Colors.teal,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                          "Limpar dados",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () => _limpar(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RaisedButton(
                        color: Colors.teal,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                          "Calcular",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          _calcularkm();
                          _textoResultado == "Preencha os campos para calcular"
                              ? _textoResultado =
                                  "Preencha os campos para fazer o calculo corretamente"
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TelaResposta(
                                      valor: _textoResultado,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: RaisedButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        "Voltar Home",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Guillotine(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
