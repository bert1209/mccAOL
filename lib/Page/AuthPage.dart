import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF777777),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50,),

              Image.asset('lib/Assets/Judul.png',
              height: 75,),

              const SizedBox(height: 50,),

              Image.asset('lib/Assets/Logo.png',
              height: 300,),

              SizedBox(height: 25,),

              //Login Button
              elevatedButtons(
                width: 300,
                textColor: const Color(0xFF555555),
                text: "Login",
                onPressed: () {
                  Navigator.pushNamed(context, '/loginPage');
                },
                height: 50,
                buttonColor: const Color(0xFFFFFFFF),
                borderRadius: 10,
                fontSize: 20,
                FontType: "Poppin",
              ),

              SizedBox(height: 15,),

              //Register Button
              elevatedButtons(
                  width: 300,
                  textColor: const Color(0xFF555555),
                  text: "Register",
                  onPressed: () {
                    Navigator.pushNamed(context, '/registerPage');
                  },
                  height: 50,
                  buttonColor: const Color(0xFFFFFFFF),
                  borderRadius: 10,
                  fontSize: 20,
                  FontType: "Poppin",
              ),
            ],
          ),
        ),
      ),
    );
  }
}