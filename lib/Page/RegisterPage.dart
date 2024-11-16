import 'package:flutter/material.dart';
import '../Function/ImageButton.dart';
import '../Function/MyTextField.dart';
import '../Function/elevatedButtons.dart';
import 'LoginPage.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

var usernameControl = TextEditingController();
var emailControl = TextEditingController();
var passwordControl = TextEditingController();
var cPasswordControl = TextEditingController();

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
              const SizedBox(height: 50,),

              Image.asset('lib/Assets/Judul.png',),

              const SizedBox(height: 75,),

              //Username TextField
              TextFields(
                controller: usernameControl,
                obscureText: false,
                hintText: "Username",
              ),

              const SizedBox(height: 20,),

              //Email TextField
              TextFields(
                hintText: "Email",
                obscureText: false,
                controller: emailControl,
              ),

              const SizedBox(height: 20,),

              //Password TextField
              TextFields(
                controller: passwordControl,
                obscureText: false,
                hintText: "Password",
              ),

              const SizedBox(height: 20,),

              //Confirm Password TextField
              TextFields(
                hintText: "Confirm Password",
                obscureText: false,
                controller: cPasswordControl,
              ),

              const SizedBox(height: 25,),

              elevatedButtons(
                width: 325,
                height: 50,
                fontSize: 25,
                text: "Register",
                textColor: const Color(0xFFFFFFFF),
                buttonColor: const Color(0xFF333333),
                onPressed: () {

                },
                borderRadius: 10,
                FontType: "Poppin",
              ),

              const SizedBox(height: 15,),

              const Text(
                "---Or Register With---",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageButton(
                    images: 'lib/Assets/google.png',
                    onTap: () {

                    },
                    height: 65,
                    widht: 65,
                    padding: 10,
                  ),
                  imageButton(
                    images: 'lib/Assets/X.png',
                    onTap: () {

                    },
                    height: 65,
                    widht: 65,
                    padding: 10,
                  ),
                ],
              ),

            ]
          )
        )
      )
    );
  }
}
