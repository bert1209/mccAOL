import 'package:flutter/material.dart';

class TextButtons extends StatelessWidget {

  final String Texts;
  final double TextSize;
  final FontWeight FontWeights;
  final VoidCallback onPress;
  const TextButtons({
    super.key,
    required this.Texts,
    required this.TextSize,
    required this.FontWeights,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            fontSize: TextSize,
            color: Colors.blue,
            fontWeight: FontWeights,
            fontFamily: "Poppin",
          ),
        ),
        onPressed: onPress,
        child: Text(Texts),
      )
    );
  }
}
