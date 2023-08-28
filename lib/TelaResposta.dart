// ignore_for_file: file_names
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quanto/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
// import 'home.dart';

// ignore: must_be_immutable
class TelaResposta extends StatefulWidget {
  // const TelaResposta({Key? key}) : super(key: key);
  String valor;

  TelaResposta({Key? key, required this.valor}) : super(key: key);

  @override
  _TelaRespostaState createState() => _TelaRespostaState();
}

class _TelaRespostaState extends State<TelaResposta> {
  void _salvarInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _email = prefs.getString('email');

    // ignore: avoid_print
    print("estou tentando");
    // ignore: avoid_print
    print(_email);

    try {
      var response = await Dio().post(
        Constants.baseUrl + "mobile/verifica",
        data: {
          'email': _email,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      // ignore: avoid_print
      print('Ok ${response.data}');

      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      // ignore: avoid_print
      print('ERRROOOOOOO -> $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quanto meu carro está rendendo'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.teal[900],
          height: MediaQuery.of(context).size.height * 1,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Image.asset("images/carro-azul.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
                child: Text(
                  widget.valor,
                  style: const TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Center(
                      child: Column(
                        children: [
                          // ignore: deprecated_member_use
                          RaisedButton(
                            color: Colors.teal,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              "Deseja salvar essa informação?",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () => _salvarInfo(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Center(
                      child: Column(
                        children: [
                          // ignore: deprecated_member_use
                          RaisedButton(
                            color: Colors.teal,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              "Voltar",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
