import 'dart:convert';
import 'package:flutter/material.dart';
import '../Function/ImageButton.dart';
import '../Function/MyTextField.dart';
import '../Function/TextButton.dart';
import '../Function/elevatedButtons.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

var usernameControl = TextEditingController();
var emailControl = TextEditingController();
var passwordControl = TextEditingController();
var cPasswordControl = TextEditingController();

void signInGoogle(BuildContext context) async {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  final GoogleSignInAccount? account = await _googleSignIn.signIn();
  if (account != null) {
    String url = "http://10.0.2.2:3000/user/insert-new-users";
    String json = jsonEncode({
      "Username": account.displayName,
      "Email": account.email,
      "Password": " ".toString(),
    });
    final resp = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json);

    if (resp.statusCode == 200) {
      Navigator.pushNamed(context, '/loginPage');
    } else if (resp.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email Already Exists'),
        ),
      );
    }
  }
}

void _insertOnPressed(BuildContext context) async {
  if (usernameControl.text == "" ||
      emailControl.text == "" ||
      passwordControl.text == "" ||
      passwordControl.text == " ") {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All Fields Must be Filled!')));
  } else {
    // Insert to DB
    String url = "http://10.0.2.2:3000/user/insert-new-users";
    String json = jsonEncode({
      "Username": usernameControl.text,
      "Email": emailControl.text,
      "Password": passwordControl.text,
    });

    final resp = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json);

    if (resp.statusCode == 200) {
      Navigator.pushNamed(context, '/loginPage');
    } else if (resp.statusCode == 400) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Email Already Exists')));
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

              Image.asset(
                'lib/Assets/Judul.png',
                height: 90,
              ),

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

              const SizedBox(height: 25),

              elevatedButtons(
                fontWeight: FontWeight.bold,
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
              const SizedBox(height: 10),
              const Text(
                "---OR---",
                style: TextStyle(
                  fontFamily: "Poppin",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // googleSignIn();
                    signInGoogle(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF333333),
                    backgroundColor: const Color(0xFF999999),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const SizedBox(width: 100),
                      SizedBox(
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xFFFFFFFF),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Image.asset(
                              "lib/Assets/googles.png",
                              height: 37,
                              width: 37,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Register With Google",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppin",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already Have an Account?"),
                  TextButtons(
                    Texts: "Sign In Now!",
                    TextSize: 15,
                    onPress: () {
                      Navigator.pushNamed(context, '/loginPage');
                    },
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
