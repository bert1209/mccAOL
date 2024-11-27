import 'package:aol_mcc/Function/Image.dart';
import 'package:aol_mcc/Function/TextFunc.dart';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Page/InsertPage.dart';
import 'package:aol_mcc/Page/ProductPage.dart';
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
      backgroundColor: Color(0xFF999999),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Container(
              height: 85,
              width: 200,
              child: Image.asset("lib/Assets/Judul.png"),
            ),
            SizedBox(height: 100),
            ImagesFunction(
              images: "lib/Assets/Success.png"
            ),
            SizedBox(height: 10),
            TextFunc(
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
            SizedBox(height: 130),
            elevatedButtons(
                width: 90,
                height: 40,
                fontSize: 20,
                text: "OK",
                textColor: Colors.white,
                buttonColor: Color(0xFF333333),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InsertPage(
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
