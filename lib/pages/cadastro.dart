// ignore_for_file: deprecated_member_use, avoid_print
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quanto/dio_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _controllerNome = TextEditingController(text: "");
  final TextEditingController _controllerEmail =
      TextEditingController(text: "");
  final TextEditingController _controllerSenha =
      TextEditingController(text: "");
  final TextEditingController _controllerConfirmarSenha =
      TextEditingController(text: "");
  String _mensagemErro = "";

  _validarCampos() {
    EasyLoading.show(status: 'Carregando...');
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

        cadastrarNewUser();
        Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
        // _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha!";
        });
        Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o E-mail utilizando @";
      });
      Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
    }
  }

  void cadastrarNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      FormData data = FormData.fromMap({
        'name': _controllerNome.text,
        'email': _controllerEmail.text,
        'password': _controllerSenha.text,
        'password_confirmation': _controllerConfirmarSenha.text,
      });

      Response res = await dioInstance().post("/auth/register", data: data);

      if (res.data['success'] == true) {
        await prefs.setString('email', _controllerEmail.text);
        await prefs.setString('nome', _controllerNome.text);
        await prefs.setInt('id', res.data['user']['id']);
        Navigator.pushReplacementNamed(context, "/tela_principal");
      }
    } catch (e) {
      String message =
          "Aconteceu algum erro com o servidor! Tente novamente mais tarde.";
      if (e is DioError) {
        print(e.response);
        if (e.response?.data['message'] != null) {
          message = e.response?.data['message'];
        }
      }
      //print('ERRO $e');
      setState(() {
        _mensagemErro = message;
      });
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
                    "assets/img/carro-azul.png",
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
                      borderRadius: BorderRadius.circular(32),
                    ),
                    onPressed: () {
                      _validarCampos();
                    },
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
