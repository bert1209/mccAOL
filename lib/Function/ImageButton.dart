import 'package:flutter/material.dart';

class imageButton extends StatelessWidget {

  final String images;
  final VoidCallback onTap;
  final double height;
  final double widht;
  final double padding;
  const imageButton({
    super.key,
    required this.images,
    required this.onTap,
    required this.height,
    required this.widht,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: InkWell(
        splashColor: Colors.black26,
        onTap: () {

        },
        child: Ink.image(
          image:
          AssetImage(images),
          height: height,
          width: widht,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
