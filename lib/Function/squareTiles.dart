import 'package:flutter/material.dart';

class squareTiles extends StatelessWidget {
  final String images;
  final double height;

  const squareTiles ({
    super.key,
    required this.images,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        images,
        height: height,)
    );
  }
}
