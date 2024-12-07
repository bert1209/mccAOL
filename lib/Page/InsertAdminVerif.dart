import 'package:aol_mcc/Function/Image.dart';
import 'package:aol_mcc/Function/TextFunc.dart';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Page/InsertPage.dart';
import 'package:flutter/material.dart';

class AdminVerificationPage extends StatefulWidget {


  const AdminVerificationPage(
      {super.key,
   });

  @override
  State<AdminVerificationPage> createState() => _AdminVerificationPageState();
}

class _AdminVerificationPageState extends State<AdminVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF999999),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 85,
              width: 200,
              child: Image.asset("lib/Assets/Judul.png"),
            ),
            const SizedBox(height: 100),
            const ImagesFunction(
              images: "lib/Assets/Success.png"
            ),
            const SizedBox(height: 10),
            const TextFunc(
              Text1: "Success",
              Text2: "Successfuly Added Banboo",
              jenisFont: "Poppin",
              tipeFont: FontWeight.bold,
              ukuranFont: 25,
              warnaFont: Colors.white,
              jenisFonts: "Poppin",
              tipeFonts: FontWeight.bold,
              ukuranFonts: 15,
              warnaFonts: Color(0xFF333333),
            ),
            const SizedBox(height: 130),
            elevatedButtons(
              fontWeight: FontWeight.bold,
                width: 90,
                height: 40,
                fontSize: 20,
                text: "OK",
                textColor: Colors.white,
                buttonColor: const Color(0xFF333333),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InsertPage(
                      ),
                    ),
                  );
                },
                borderRadius: 15,
                FontType: "Poppin")
          ],
        ),
      )),
    );
  }
}
