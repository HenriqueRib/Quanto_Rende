import 'dart:io';
import 'package:flutter/material.dart';
import 'aplicacao.dart';
import 'login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
  // runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Login()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
