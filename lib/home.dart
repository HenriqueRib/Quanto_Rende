import 'package:flutter/material.dart';
import 'package:quanto_rendes/TelaResposta.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controllerkmFinal = TextEditingController();
  final TextEditingController _controllerkmInicial = TextEditingController();
  final TextEditingController _controllerQtdCombustivel =
      TextEditingController();
  String _textoResultado = "Descubra quanto que seu carro está rendendo";
  var _controller = TextEditingController();

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
    setState(() {
      _textoResultado = "Descubra quanto que seu carro está rendendo";
      _controllerkmFinal.clear();
      _controllerkmInicial.clear();
      _controllerQtdCombustivel.clear();
    });
  }

  List<Widget> telas = [Inicio(), EmAlta(), Inscricao(), Biblioteca()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Image.asset(
          "imagens/youtube.png",
          width: 98,
          height: 22,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              print("acao: videocam");
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print("acao: pesquisa");
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              print("acao: conta");
            },
          )
        ],
      ),
      body: telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: (indice) {
            setState(() {
              _indiceAtual = indice;
            });
          },
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.red,
          items: [
            BottomNavigationBarItem(
                //backgroundColor: Colors.orange,
                title: Text("Início"),
                icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                //backgroundColor: Colors.red,
                title: Text("Em alta"),
                icon: Icon(Icons.whatshot)),
            BottomNavigationBarItem(
                //backgroundColor: Colors.blue,
                title: Text("Inscrições"),
                icon: Icon(Icons.subscriptions)),
            BottomNavigationBarItem(
                //backgroundColor: Colors.green,
                title: Text("Biblioteca"),
                icon: Icon(Icons.folder)),
          ]),
    );
  }
}
