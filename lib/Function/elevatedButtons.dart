import 'package:flutter/material.dart';

class elevatedButtons extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final double borderRadius;
  final double width;
  final double height;
  final double fontSize;
  final String FontType;
  final FontWeight fontWeight;

  const elevatedButtons({
    super.key,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.text,
    required this.textColor,
    required this.buttonColor,
    required this.onPressed,
    required this.borderRadius,
    required this.FontType,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: FontType,
            ),
          ),
        ));
  }
}
