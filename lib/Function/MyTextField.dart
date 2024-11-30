import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const TextFields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        style: TextStyle(fontFamily: "Poppin"),
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF777777),
              ),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF333333),
              ),
              borderRadius: BorderRadius.circular(15)),
          fillColor: const Color(0xFFFFFFFF),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
