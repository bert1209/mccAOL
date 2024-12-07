import 'package:aol_mcc/Page/AuthPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthPage()),
        );
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context)
        .size
        .height; //buat screen height tapi pake persentase dari screen
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF777777), Color(0xFF333333)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: screenWidth * 0.5),
            Image.asset('lib/Assets/splashScreen.png'),
            SizedBox(height: screenHeight * 0.02),
            const Text(
              'BANBOO STORE',
              style: TextStyle(
                fontFamily: 'Bangers',
                fontSize: 40,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: screenHeight * 0.15),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
