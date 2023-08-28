//import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  // Constants.siteUrl
  static const String baseUrl = "https://app.codeline43.com.br";
//  static const String baseUrl = "http://10.0.2.2:8000"; // Emulador job
//  static const String baseUrl = "http://10.0.0.142:3000"; // Display casa npm
//  static const String baseUrl = "http://192.168.0.71:3000"; // Job

  // static const String baseUrl = "http://127.0.0.1:8000"; // Sem internet
  static const String apiUrl = "$baseUrl/api";
  static const String baseColor = "Colors.teal[900]";
  static const String baseColor2 = "Colors.blue[200]";
}

// getConfig() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('menu_title', 'Visualizar'); // salvar
//   // final String? _email = prefs.getString('email'); // Recuperar
// }
