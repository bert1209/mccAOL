import 'package:aol_mcc/Page/AuthPage.dart';
import 'package:aol_mcc/Page/LoginPage.dart';
import 'package:aol_mcc/Page/RegisterPage.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/loginPage': (context) => LoginPage(),
        '/registerPage': (context) => RegisterPage(),

      },
    );
  }
}
