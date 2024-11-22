import 'dart:convert';

import 'package:aol_mcc/Function/ImageButton.dart';
import 'package:aol_mcc/Function/MyTextField.dart';
import 'package:aol_mcc/Function/TextButton.dart';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Page/ProfilePage.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//Text Editing Controller
var emailControl = TextEditingController();
var passwordControl = TextEditingController();

void _insertOnPressed(BuildContext context) async {
  var validate =
      "http://10.0.2.2:3000/banboos/${emailControl.text}/${passwordControl.text}/Role";
  var login = await http.get(
    Uri.parse(validate),
    headers: {"Content-Type": "application/json"},
  );

  print(login.body);

  if (login.statusCode == 200 && login.body != '[]') {
    var role =
        "http://10.0.2.2:3000/banboos/${emailControl.text}/${passwordControl.text}/Role";
    var roleCheck = await http.get(
      Uri.parse(role),
      headers: {"Content-Type": "application/json"},
    );
    if (roleCheck.statusCode == 200 && roleCheck.body.contains('1')) {
      Navigator.pushNamed(context, '/insertPage');
    } else {
      //Navigator.pushNamed(context, '/adminHomePage');
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
            );
          },
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

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF777777),
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
                  height: 100,
                ),

                //Username TextField
                TextFields(
                  controller: emailControl,
                  obscureText: false,
                  hintText: "Username",
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
                const SizedBox(
                  height: 10,
                ),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Didn't have an account?"),
                  TextButtons(
                    Texts: "Register Now!",
                    TextSize: 15,
                    TextColor: const Color(0xFF1e0fbe),
                    FontWeights: FontWeight.bold,
                    onPress: () {
                      Navigator.pushNamed(context, '/registerPage');
                    },
                  )
                ]),
              ],
            ),
          ),
        ));
  }
}
