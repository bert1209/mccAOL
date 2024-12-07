import 'dart:convert';
// import 'dart:html';
// import 'dart:html';
// import 'dart:html';

import 'package:aol_mcc/Function/AuthService.dart';
import 'package:aol_mcc/Function/ImageButton.dart';
import 'package:aol_mcc/Function/MyTextField.dart';
import 'package:aol_mcc/Function/TextButton.dart';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Function/googleAuth.dart';
import 'package:aol_mcc/Function/user.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//Text Editing Controller
var emailControl = TextEditingController();
var passwordControl = TextEditingController();

void signInGoogles(BuildContext context) async {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  final GoogleSignInAccount? account = await _googleSignIn.signIn();
  if (account != null) {
    print({account.displayName});
    print({account.email});

    var validate =
        "http://10.0.2.2:3000/banboos/${account.email}/${" ".toString()}";
    var login = await http.get(
      Uri.parse(validate),
      headers: {"Content-Type": "application/json"},
    );
    // // ignore: avoid_print
    print(login.body);
    var data = json.decode(login.body);
    AuthService.loggedUser = user.fromJson(data);
    if (login.statusCode == 200 && login.body != "[]") {
      // ignore: avoid_print
      print("halo");
      var role =
          "http://10.0.2.2:3000/banboos/${account.email}/${" ".toString()}";
      var roleCheck = await http.get(
        Uri.parse(role),
        headers: {"Content-Type": "application/json"},
      );
      if (roleCheck.statusCode == 200) {
        String url = "http://10.0.2.2:3000/banboos/get-role";
        String json = jsonEncode({
          "Email": account.email.toString(),
        });
        var resp = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json,
        );
        var result = jsonDecode(resp.body);
        if (result[0]["Role"] == 1) {
          Navigator.pushNamed(context, '/insertPage');
        } else {
          String url = "http://10.0.2.2:3000/banboos/get-id";
          String json = jsonEncode({
            "Email": account.email.toString(),
          });

          var resp = await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: json,
          );
          var result = jsonDecode(resp.body);
          var navigator = Navigator.of(context);
          navigator.push(
            MaterialPageRoute(
              builder: (builder) {
                return HomePage(
                  UserID: result[0]["UserID"],
                  UserMoney: result[0]["UserMoney"],
                );
              },
            ),
          );
        }
        // Navigator.pushNamed(context, '/insertPage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error Login',
              style: TextStyle(
                fontFamily: 'Poppin',
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Wrong Email or Password',
            style: TextStyle(
              fontFamily: 'Poppin',
            ),
          ),
        ),
      );
    }
  }
}

void _insertOnPressed(BuildContext context) async {
  if (passwordControl.text != " " ||
      passwordControl.text != "" ||
      emailControl != "") {
    var validate =
        "http://10.0.2.2:3000/banboos/${emailControl.text}/${passwordControl.text}";
    var login = await http.get(Uri.parse(validate),
        headers: {"Content-Type": "application/json"});
    // ignore: avoid_print
    // print(login.body);
    var data = json.decode(login.body);
    // ignore: avoid_print
    print(data);
    AuthService.loggedUser = user.fromJson(data);
    if (login.statusCode == 200 && login.body != "[]") {
      // ignore: avoid_print
      print("halo");
      var role =
          "http://10.0.2.2:3000/banboos/${emailControl.text}/${passwordControl.text}";
      var roleCheck = await http.get(
        Uri.parse(role),
        headers: {"Content-Type": "application/json"},
      );
      if (roleCheck.statusCode == 200) {
        String url = "http://10.0.2.2:3000/banboos/get-role";
        String json = jsonEncode({
          "Email": emailControl.text,
        });
        var resp = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json,
        );
        var result = jsonDecode(resp.body);
        if (result[0]["Role"] == 1) {
          Navigator.pushNamed(context, '/insertPage');
        } else {
          String url = "http://10.0.2.2:3000/banboos/get-id";
          String json = jsonEncode({
            "Email": emailControl.text,
          });

          var resp = await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: json,
          );
          var result = jsonDecode(resp.body);
          var navigator = Navigator.of(context);
          navigator.push(
            MaterialPageRoute(
              builder: (builder) {
                return HomePage(
                  UserID: result[0]["UserID"],
                  UserMoney: result[0]["UserMoney"],
                );
              },
            ),
          );
        }
        // Navigator.pushNamed(context, '/insertPage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error Login',
              style: TextStyle(
                fontFamily: 'Poppin',
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Wrong Email or Password',
            style: TextStyle(
              fontFamily: 'Poppin',
            ),
          ),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'All Fields must be filled!',
          style: TextStyle(
            fontFamily: 'Poppin',
          ),
        ),
      ),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF777777),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),

              Image.asset(
                'lib/Assets/Judul.png',
              ),

              const SizedBox(
                height: 90,
              ),

              //Username TextField
              TextFields(
                controller: emailControl,
                obscureText: false,
                hintText: "Email",
              ),

              const SizedBox(
                height: 25,
              ),

              //Password TextField
              TextFields(
                hintText: "Password",
                obscureText: true,
                controller: passwordControl,
              ),

              const SizedBox(
                height: 15,
              ),

              elevatedButtons(
                width: 325,
                height: 50,
                fontSize: 25,
                text: "Sign In",
                textColor: const Color(0xFFFFFFFF),
                buttonColor: const Color(0xFF333333),
                onPressed: () {
                  _insertOnPressed(context);
                  //passingID();
                  // Navigator.pushNamed(context, '/homePage');
                  //},
                },
                borderRadius: 10,
                FontType: "Poppin",
              ),

              const SizedBox(
                height: 25,
              ),

              const Text(
                "---Or Continue With---",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 15,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      // googleSignIn();
                      signInGoogles(context);
                      // signOutGoogle();
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
                        Image.asset(
                          "lib/Assets/google.png",
                          height: 37,
                          width: 37,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Google",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Poppin",
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 10,
              ),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Didn't have an account?"),
                TextButtons(
                  Texts: "Register Now!",
                  TextSize: 15,
                  FontWeights: FontWeight.bold,
                  onPress: () {
                    Navigator.pushNamed(context, '/registerPage');
                  },
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
