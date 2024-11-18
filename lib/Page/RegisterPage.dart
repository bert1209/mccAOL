import 'dart:convert';
import 'package:flutter/material.dart';
import '../Function/ImageButton.dart';
import '../Function/MyTextField.dart';
import '../Function/elevatedButtons.dart';
import 'LoginPage.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

var usernameControl = TextEditingController();
var emailControl = TextEditingController();
var passwordControl = TextEditingController();
var cPasswordControl = TextEditingController();

void _insertOnPressed(BuildContext context) async {
  if (usernameControl.text == "" ||
      emailControl.text == "" ||
      passwordControl.text == "" ||
      cPasswordControl.text == "") {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All Fields Must be Filled!')));
  } else {
    // Insert to DB
    String url = "http://10.0.2.2:3000/banboos/insert-new-users";
    String json = jsonEncode({
      "Username": usernameControl.text,
      "Email": emailControl.text,
      "Password": passwordControl.text,
    });

    final resp = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json);

    if (resp.statusCode == 200 && passwordControl == cPasswordControl) {
      Navigator.pushNamed(context, '/homePage');
    } else if (resp.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email Already Exists')));
    }
  }
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF777777),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              Image.asset('lib/Assets/Judul.png'),

              const SizedBox(height: 75),

              // Username TextField
              TextFields(
                controller: usernameControl,
                obscureText: false,
                hintText: "Username",
              ),

              const SizedBox(height: 20),

              // Email TextField
              TextFields(
                hintText: "Email",
                obscureText: false,
                controller: emailControl,
              ),

              const SizedBox(height: 20),

              // Password TextField
              TextFields(
                controller: passwordControl,
                obscureText: true,
                hintText: "Password",
              ),

              const SizedBox(height: 20),

              // Confirm Password TextField
              TextFields(
                hintText: "Confirm Password",
                obscureText: true,
                controller: cPasswordControl,
              ),

              const SizedBox(height: 25),

              elevatedButtons(
                width: 325,
                height: 50,
                fontSize: 25,
                text: "Register",
                textColor: const Color(0xFFFFFFFF),
                buttonColor: const Color(0xFF333333),
                onPressed: () => _insertOnPressed(context),
                borderRadius: 10,
                FontType: "Poppin",
              ),

              const SizedBox(height: 15),

              const Text(
                "---Or Register With---",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageButton(
                    images: 'lib/Assets/google.png',
                    onTap: () {},
                    height: 65,
                    widht: 65,
                    padding: 10,
                  ),
                  imageButton(
                    images: 'lib/Assets/X.png',
                    onTap: () {},
                    height: 65,
                    widht: 65,
                    padding: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}