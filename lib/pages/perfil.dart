// ignore_for_file: deprecated_member_use, duplicate_ignore
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:quanto/dio_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final String? _email = prefs.getString('email');
      FormData data = FormData.fromMap({
        'email': _email,
      });
      Response res =
          await dioInstance().post("/quanto_rendes/user", data: data);

      setState(() {
        _controllerNome.text = res.data['data'][0]['name'];
        _controllerEmail.text = res.data['data'][0]['email'];
      });
    } catch (e) {
      // print('ERRO $e');
    }
  }

  _atualizarDados() async {
    EasyLoading.show(status: 'Carregando...');
    final prefs = await SharedPreferences.getInstance();
    try {
      final String? _email = prefs.getString('email');
      FormData data = FormData.fromMap({
        'email': _email,
        'name': _controllerNome.text,
      });
      Response res = await dioInstance().post("/auth/update/user", data: data);
      if (res.data['status'] == 'success') {
        await prefs.setString('nome', _controllerNome.text);
        EasyLoading.dismiss();
        EasyLoading.showSuccess(
            'Suas informações de Perfil foram atualizadas com Sucesso');
        Navigator.pushReplacementNamed(context, "/tela_principal");
        Timer(const Duration(seconds: 4), () => EasyLoading.dismiss());
      }
    } catch (e) {
      Timer(const Duration(seconds: 1), () => EasyLoading.dismiss());
      // print(e);
    }
  }

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal[900],
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: 1.sw,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Nome",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1.sw,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "E-mail",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    enabled: false,
                    controller: _controllerEmail,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.teal,
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    onPressed: () {
                      _atualizarDados();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
