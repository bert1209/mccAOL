import 'package:flutter/material.dart';

class ImagesFunction extends StatelessWidget {
  final String images;
  const ImagesFunction(
      {super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Image.asset(images),
    );
  }
}
