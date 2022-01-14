// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
// import 'model/Usuario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      wordSpacing: 0,
      decoration: TextDecoration.none,
      color: Colors.redAccent);

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

        // Usuario usuario = Usuario();
        // usuario.email = email;
        // usuario.senha = senha;

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
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
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
                    style: const TextStyle(fontSize: 20),
                    // ignore: prefer_const_constructors
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'E-mail',
                      labelStyle: const TextStyle(
                        fontFamily: 'CalibriBold',
                        fontSize: 16,
                        color: Colors.black,
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
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Senha',
                    labelStyle: const TextStyle(
                      fontFamily: 'CalibriBold',
                      fontSize: 16,
                      color: Colors.black,
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: const Text(
                        "Entrar",
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
                Center(
                  child: GestureDetector(
                    child: const Text("Não tem conta? cadastre-se!",
                        style: TextStyle(color: Colors.white)),
                    // onTap: () {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => Cadastro()));
                    // },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: const Text("Pular etapa e apenas Calcular!",
                        style: TextStyle(color: Colors.blue, fontSize: 25)),
                    // onTap: () {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => Cadastro()));
                    // },
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
