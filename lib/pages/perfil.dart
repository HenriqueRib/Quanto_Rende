// ignore_for_file: deprecated_member_use, duplicate_ignore
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
      final String? _email = prefs.getString('email'); // Recuperar
      FormData data = FormData.fromMap({
        'email': _email,
      });
      Response res =
          await dioInstance().post("/quanto_rendes/user", data: data);
      // print(res.data['data'][0]);

      setState(() {
        _controllerNome.text = res.data['data'][0]['name'];
        _image = res.data['data'][0]['image'];
      });
    } catch (e) {
      // print('ERRO $e');
    }
  }

  _newPhotoCamera() async {
    // _photo = await picker.pickImage(source: ImageSource.camera);
    // setState(() {
    //   _image = _photo!.path;
    // });
  }

  _newPhotoGaleria() async {
    // _photo = await picker.pickImage(source: ImageSource.gallery);
    // setState(() {
    //   _image = _photo!.path;
    // });
  }

  _atualizarDados() async {
    EasyLoading.show(status: 'Carregando...');
    final prefs = await SharedPreferences.getInstance();
    try {
      final String? _email = prefs.getString('email');
      FormData data = FormData.fromMap({
        'email': _email,
        'name': _controllerNome.text,
        // 'image': await MultipartFile.fromFile(_photo!.path),
      });
      //TODO: Verificar porque nao esta salvando a imagem.

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

  final bool _subindoImagem = false;
  final TextEditingController _controllerNome = TextEditingController();
  // ImagePicker picker = ImagePicker();
  String? _image;
  // XFile? _photo;

  @override
  Widget build(BuildContext context) {
    if (_image is! String || _image == 'null') {
      _image = 'assets/img/userdefault.png';
    }

    return Scaffold(
      body: Container(
        color: Colors.teal[900],
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: _subindoImagem
                      ? const CircularProgressIndicator()
                      : Container(),
                ),
                ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(120),
                    child: Stack(
                      children: [
                        Image.asset(
                          "$_image",
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 1,
                          width: 1,
                          color: Colors.black54,
                          child: const Icon(
                            Icons.camera_alt_sharp,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      padding: const EdgeInsets.all(10),
                      onPressed: () async {
                        _newPhotoCamera();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 50,
                          ),
                          Text(
                            'Câmera',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Calibri',
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    RawMaterialButton(
                      padding: const EdgeInsets.all(10),
                      onPressed: () async {
                        _newPhotoGaleria();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                            size: 50,
                          ),
                          Text(
                            'Galeria',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Calibri',
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
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
