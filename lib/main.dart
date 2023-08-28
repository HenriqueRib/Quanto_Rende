import 'dart:io';
import 'dart:async';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quanto/menu/configuracao.dart';
import 'package:quanto/menu/editar.dart';
import 'package:quanto/menu/guillotine.dart';
import 'package:quanto/menu/marcar.dart';
import 'package:quanto/menu/perfil.dart';
import 'package:quanto/menu/visualizar.dart';
import 'package:quanto/pages/aplicacao.dart';
import 'package:quanto/pages/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanto/pages/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_) => MaterialApp(
        title: 'Quanto Rendes',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        builder: (context, widget) {
          widget = _getSnack(widget);
          widget = EasyLoading.init()(context, widget);
          return widget;
        },
        debugShowCheckedModeBanner: false,
        home: const Login(),
        routes: {
          '/tela_principal': (context) => const Guillotine(),
          '/editar': (context) => const Editar(),
          '/menu': (context) => const Menu(),
          '/login': (context) => const Login(),
          '/perfil': (context) => const Perfil(),
          '/marcar': (context) => const Marcar(),
          '/aplicacao': (context) => const Aplicacao(),
          '/visualizar': (context) => const Visualizar(),
          '/configuracao': (context) => const Configuracao(),
        },
      ),
    );
  }

  _getSnack(widget) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            return ToastProvider(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              ),
            );
          },
        ),
      ],
    );
  }
}
