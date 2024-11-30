import 'package:aol_mcc/Page/AuthPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aol_mcc/Page/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  @override

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => AuthPage()
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; //buat screen height tapi pake persentase dari screen
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF777777), Color(0xFF333333)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/Assets/splashScreen.png'),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'BANBOO STORE',
              style: TextStyle(
                fontFamily: 'Bangers',
                fontSize: 40,
                color: Colors.white70
              )
            )
          ],
        )
      ),
    );
  }
}

