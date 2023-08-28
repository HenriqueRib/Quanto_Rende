// ignore_for_file: deprecated_member_use, avoid_print
import 'package:flutter/material.dart';
import 'package:quanto_rendes/aplicacao.dart';
import 'package:dio/dio.dart';
import 'package:quanto_rendes/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cadastro.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail =
      TextEditingController(text: "");
  final TextEditingController _controllerSenha =
      TextEditingController(text: "");
  String _mensagemErro = "";

  _validarCampos() {
    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        getHttp();
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
    final prefs = await SharedPreferences.getInstance();
    print('getHttp');

    try {
      var response = await Dio().post(
        Constants.siteUrl + "login",
        data: {
          'email': _controllerEmail.text,
          'password': _controllerSenha.text,
        },
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      print('getHttp');

      setState(() {
        _mensagemErro = "Cadastrado com sucesso!";
      });
      await prefs.setString('email', _controllerEmail.text);

      print('Ok ${response.data}');

      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      setState(() {
        _mensagemErro = "Erro!";
      });

      print('ERRROOOOOOO -> $e');
    }
  }

  String loginController = '';

  // _logarUsuario(Usuario usuario) {}

  Future _verificarUsuarioLogado() async {}

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  // @override
  // Future<void> initState() async {
  //   _verificarUsuarioLogado();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "images/carro-azul.png",
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
                        icon: Icon(
                          loginController != ''
                              // &&
                              //         loginController.email!.length > 0
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
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
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
                      icon: Icon(
                        loginController != ''
                            // &&
                            //         loginController.email!.length > 0
                            ? Icons.clear
                            : Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: RaisedButton(
                    color: const Color(0xff91998A),
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _validarCampos();
                    },
                    child: const Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 0),
                ),
                Center(
                  child: GestureDetector(
                    child: const Text(
                      "Não tem conta? cadastre-se!",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Cadastro(),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20, bottom: 20)),
                Center(
                  child: RaisedButton(
                    child: const Text(
                      "Apenas Calcular!",
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
                          builder: (context) => const Home(),
                        ),
                      );
                    },
                  ),
                  // child: GestureDetector(
                  //   child: const Text("Pular etapa e apenas Calcular!",
                  //       style: TextStyle(color: Colors.blue, fontSize: 25)),
                  // onTap: () {
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => Cadastro()));
                  // },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
