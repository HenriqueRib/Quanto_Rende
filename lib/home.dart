import 'package:flutter/material.dart';
import 'package:quantorendes/TelaResposta.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerkmFinal = TextEditingController();
  TextEditingController _controllerkmInicial = TextEditingController();
  TextEditingController _controllerQtdCombustivel = TextEditingController();
  String  _textoResultado = "Descubra quanto que seu carro está rendendo";
  var _controller = TextEditingController();

  _calcularkm(){
    int kmfinal = int.parse(_controllerkmFinal.text);
    int kminicial = int.parse(_controllerkmInicial.text);
    double qtdCombustivel = double.parse(_controllerQtdCombustivel.text);
    int resultado;
    double _kmPorLitro;

    resultado = kmfinal - kminicial;
    setState(() {
      _kmPorLitro = resultado / qtdCombustivel;
      _textoResultado = " Desta vez seu carro fez " + _kmPorLitro.toStringAsFixed(_kmPorLitro.truncateToDouble() == _kmPorLitro ? 0 : 2) + "km por Combustível!";
    });

  }
  _limpar(){

    setState(() {
      _textoResultado = "Descubra quanto que seu carro está rendendo";
      _controllerkmFinal.clear();
      _controllerkmInicial.clear();
      _controllerQtdCombustivel.clear();
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
              Padding(padding: EdgeInsets.only(bottom: 12),
              child: Image.asset("images/carro-azul.png"),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  _textoResultado,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Km Final, ex: 73111",
                    suffixIcon: IconButton(
                      onPressed: () => _controllerkmFinal.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                style: TextStyle(
                    fontSize: 19
                ),
                controller: _controllerkmFinal,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Km Inicial, ex: 72878",
                    suffixIcon: IconButton(
                      onPressed: () => _controllerkmInicial.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                style: TextStyle(
                    fontSize: 19
                ),
                controller: _controllerkmInicial,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Qtd de Combustível, ex: 13.5",
                    suffixIcon: IconButton(
                      onPressed: () => _controllerQtdCombustivel.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                style: TextStyle(
                    fontSize: 19
                ),
                controller: _controllerQtdCombustivel,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                    color: Colors.indigo,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Calcular",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    //onPressed: _calcularkm
                  onPressed: (){
                      _calcularkm();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaResposta(valor: _textoResultado,)
                        )
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: RaisedButton(
                    color: Colors.indigo,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Limpar dados",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    onPressed:() =>  _limpar(),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}