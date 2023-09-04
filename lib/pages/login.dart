// ignore_for_file: deprecated_member_use, avoid_print
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quanto/dio_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cadastro.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  // _logarUsuario(Usuario usuario) {}
  Future _verificarUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _email = prefs.getString('email');
    // print("página login $_email");

    if (_email != null) {
      if (_email != "null") {
        Navigator.pushReplacementNamed(context, "/tela_principal");
      }
    }
  }

  final TextEditingController _controllerEmail =
      TextEditingController(text: "");
  final TextEditingController _controllerSenha =
      TextEditingController(text: "");
  String _mensagemErro = "";
  String loginController = '';
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();

  _validarCampos() {
    EasyLoading.show(status: 'Carregando...');
    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });
        _fazerLogin();
        Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
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

  void _fazerLogin() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      FormData data = FormData.fromMap({
        'email': _controllerEmail.text,
        'password': _controllerSenha.text,
      });

      Response res = await dioInstance().post("/auth/login", data: data);

      // print('Ok ${res.data['user']['name']}');
      if (res.data['status'] == 'success') {
        await prefs.setString('email', _controllerEmail.text);
        await prefs.setString('nome', res.data['user']['name']);
        await prefs.setInt('id', res.data['user']['id']);
        Navigator.pushReplacementNamed(context, "/tela_principal");
      }
    } catch (e) {
      String message = "Erro! Tente novamente mais tarde.";
      if (e is DioError) {
        if (e.response?.data['message'] != null) {
          message = e.response?.data['message'];
        }
      }
      print('ERRO $e');
      setState(
        () {
          _mensagemErro = message;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: Container(
          color: Colors.teal[900],
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      "assets/img/carro-azul.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 05, bottom: 0),
                    child: Center(
                      child: Text(
                        _mensagemErro,
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      focusNode: _focusEmail,
                      controller: _controllerEmail,
                      // autofocus: false,
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
                          icon: Icon(
                            loginController != ''
                                ? Icons.clear
                                : Icons.email_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _controllerSenha,
                    focusNode: _focusPassword,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
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
                        icon: Icon(
                          loginController != '' ? Icons.clear : Icons.lock,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      color: const Color(0xff91998A),
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      onPressed: () {
                        _validarCampos();
                      },
                      child: const Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: GestureDetector(
                  //     child: const Text(
                  //       "Não tem conta? cadastre-se!",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const Cadastro(),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  const Padding(padding: EdgeInsets.only(top: 0, bottom: 20)),
                  Center(
                    child: RaisedButton(
                      child: const Text(
                        "Não tem conta? cadastre-se!",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: const Color(0x00000000),
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Cadastro(),
                          ),
                        );
                      },
                    ),
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
