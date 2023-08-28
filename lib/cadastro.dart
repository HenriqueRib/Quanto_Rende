// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:quanto_rendes/util/constants.dart';
import 'aplicacao.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  // ignore: unused_field
  final TextEditingController _controllerNome = TextEditingController(text: "");

  // ignore: unused_field
  final TextEditingController _controllerEmail =
      TextEditingController(text: "");

  // ignore: unused_field
  final TextEditingController _controllerSenha =
      TextEditingController(text: "");

  // ignore: unused_field
  final TextEditingController _controllerConfirmarSenha =
      TextEditingController(text: "");

  // ignore: unused_field
  String _mensagemErro = "";

  _validarCampos() {
    //Recupera dados dos campos
    // String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    // String confirmarSenha = _controllerConfirmarSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        getHttp();

        // _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o E-mail utilizando @";
      });
    }
  }

  void getHttp() async {
    try {
      var response = await Dio().post(
        Constants.siteUrl + "mobile/registercustom",
        data: {
          'name': _controllerNome.text,
          'email': _controllerEmail.text,
          'password': _controllerSenha.text,
          'password_confirmation': _controllerConfirmarSenha.text,
        },
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      setState(() {
        _mensagemErro = "Cadastrado com sucesso!";
      });

      // ignore: avoid_print
      print('Oiiiiii');
      // ignore: avoid_print
      print(response.data);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      setState(() {
        _mensagemErro = "Erro!";
      });

      // ignore: avoid_print
      print('ERRROOOOOOO');
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar usuário'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.teal[900],
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Image.asset(
                    "images/carro-azul.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 05, bottom: 02),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerNome,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Nome',
                    labelStyle: const TextStyle(
                      fontFamily: 'CalibriBold',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // loginController.clearField('email');
                      },
                      icon: const Icon(
                        Icons.people_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    // ignore: prefer_const_constructors
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'E-mail',
                      labelStyle: const TextStyle(
                        fontFamily: 'CalibriBold',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // loginController.clearField('email');
                        },
                        icon: const Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Senha',
                    labelStyle: const TextStyle(
                      fontFamily: 'CalibriBold',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // loginController.clearField('email');
                      },
                      icon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerConfirmarSenha,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Confirmar Senha',
                    labelStyle: const TextStyle(
                      fontFamily: 'CalibriBold',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // loginController.clearField('email');
                      },
                      icon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: RaisedButton(
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: const Color(0xff91998A),
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
