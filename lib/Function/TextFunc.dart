import 'package:flutter/material.dart';

class TextFunc extends StatelessWidget {
  final String Text1;
  final String Text2;
  final String jenisFont;
  final FontWeight tipeFont;
  final double ukuranFont;
  final Color warnaFont;
  final String jenisFonts;
  final FontWeight tipeFonts;
  final double ukuranFonts;
  final Color warnaFonts;
  const TextFunc({
    super.key,
    required this.Text1,
    required this.Text2,
    required this.jenisFont,
    required this.tipeFont,
    required this.ukuranFont,
    required this.warnaFont,
    required this.jenisFonts,
    required this.tipeFonts,
    required this.ukuranFonts,
    required this.warnaFonts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Text1,
          style: TextStyle(
            fontFamily: jenisFont,
            fontSize: ukuranFont,
            fontWeight: tipeFont,
            color: warnaFont,
          ),
        ),
        Text(
          Text2,
          style: TextStyle(
            fontFamily: jenisFonts,
            fontSize: ukuranFonts,
            fontWeight: tipeFonts,
            color: warnaFonts,
          ),
        ),
      ],
    );
  }
}
