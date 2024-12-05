import 'package:aol_mcc/Function/Image.dart';
import 'package:aol_mcc/Function/TextFunc.dart';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Page/ProductPage.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  final int UserID;
  final int UserMoney;
  final int BanbooID;
  final String Images;
  final String Text1;
  final String Text2;

  const VerificationPage(
      {super.key,
      required this.UserID,
      required this.UserMoney,
      required this.Images,
      required this.Text1,
      required this.Text2,
      required this.BanbooID});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
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
            ImagesFunction(
              images: widget.Images,
            ),
            const SizedBox(height: 10),
            TextFunc(
              Text1: widget.Text1,
              Text2: widget.Text2,
              jenisFont: "Poppin",
              tipeFont: FontWeight.bold,
              ukuranFont: 25,
              warnaFont: Colors.white,
              jenisFonts: "Poppin",
              tipeFonts: FontWeight.bold,
              ukuranFonts: 15,
              warnaFonts: const Color(0xFF333333),
            ),
            const SizedBox(height: 130),
            elevatedButtons(
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
                      builder: (context) => ProductPage(
                        UserID: widget.UserID,
                        UserMoney: widget.UserMoney,
                        BanbooID: widget.BanbooID,
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
