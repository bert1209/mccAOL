import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  String money;

  Wallet({super.key, required this.money});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.money.toString());
  }
}
