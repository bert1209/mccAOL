import 'package:aol_mcc/Page/AuthPage.dart';
import 'package:aol_mcc/Page/InsertPage.dart';
import 'package:aol_mcc/Page/LoginPage.dart';
import 'package:aol_mcc/Page/ProfilePage.dart';
import 'package:aol_mcc/Page/RegisterPage.dart';
import 'package:aol_mcc/Page/StorePage.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:aol_mcc/Page/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Page/UpdatePage.dart';
import 'Page/adminHomePage.dart';



void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF777777),
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(UserID: 1,),
      routes: {
        '/loginPage': (context) => const LoginPage(),
        '/registerPage': (context) => const RegisterPage(),
        '/homePage': (context) =>  HomePage(UserID: 13),
        '/adminHomePage' : (context) => const AdminHomePage(),
        '/insertPage' : (context) => const InsertPage(),
      },
    );
  }
}
