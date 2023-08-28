// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:quanto/pages/TelaResposta.dart';

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

  // ignore: unused_field
  int _selectedIndex = 0;

  // ignore: unused_element
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {}
  }

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
    } catch (e) {
      setState(() {
        _textoResultado = "Preencha os campos para calcular";
      });
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

  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Index 0: Home',
  //   ),
  //   Text(
  //     'Index 1: Business',
  //   ),
  //   Text(
  //     'Index 2: School',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quanto meu carro está rendendo'),
        backgroundColor: Colors.teal,
        shadowColor: Colors.black,
      ),
      // body: Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
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
                child: Image.asset("images/carro-azul.png"),
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
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 15, right: 15),
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
                    padding:
                        const EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: RaisedButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        "Calcular",
                        style: TextStyle(fontSize: 20),
                      ),
                      //onPressed: _calcularkm
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
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Business',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.school),
      //       label: 'School',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
