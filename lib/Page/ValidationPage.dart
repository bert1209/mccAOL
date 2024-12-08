import 'package:aol_mcc/Function/Image.dart';
import 'package:aol_mcc/Function/TextFunc.dart';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Page/TopUpPage.dart';
import 'package:flutter/material.dart';

class ValidationPage extends StatefulWidget {
  final int UserID;
  final int UserMoney;
  final String Images;
  final String Text1;
  final String Text2;

  const ValidationPage(
      {super.key,
      required this.UserID,
      required this.UserMoney,
      required this.Images,
      required this.Text1,
      required this.Text2,});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; //buat screen height tapi pake persentase dari screen

    return Scaffold(
      backgroundColor: const Color(0xFF777777),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 85,
              width: 200,
              child: Image.asset("lib/Assets/Judul.png"),
            ),
            SizedBox(height: screenHeight * 0.2),
            ImagesFunction(
              images: widget.Images,
            ),
            SizedBox(height: screenHeight * 0.01),
            TextFunc(
              Text1: widget.Text1,
              Text2: widget.Text2,
              jenisFont: "Poppin",
              tipeFont: FontWeight.bold,
              ukuranFont: 30,
              warnaFont: Colors.white,
              jenisFonts: "SemiPoppins",
              tipeFonts: FontWeight.bold,
              ukuranFonts: 16,
              warnaFonts: const Color(0xFF333333),
            ),
            SizedBox(height: screenHeight * 0.15),
            elevatedButtons(
              fontWeight: FontWeight.bold,
                width: 100,
                height: 40,
                fontSize: 20,
                text: "Ok",
                textColor: Color(0xFFEFEFEF),
                buttonColor: const Color(0xFF333333),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopUpPage(
                        UserID: widget.UserID,
                        UserMoney: widget.UserMoney,
                      ),
                    ),
                  );
                },
                borderRadius: 10,
                FontType: 'SemiPoppins')
          ],
        ),
      )),
    );
  }
}
