import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'aplicacao.dart';
import 'login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SharedPreferences? sharedPreferences;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  // sharedPreferences = await SharedPreferences.getInstance();
  // runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
  // runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Login()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: () => MaterialApp(
        title: 'Quanto Rendes',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        builder: (context, widget) {
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        debugShowCheckedModeBanner: false,
        home: const Login(),
        routes: {
          '/home': (context) => const Home(),
        },
      ),
    );
  }
}
