import 'package:flutter/material.dart';

class navBar extends StatelessWidget {
  const navBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(
        right: 24,
        bottom: 24,
        left: 24,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF999999),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF333333),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            padding: EdgeInsets.only(top: 10.5),
            onPressed: () {},
            icon: Icon(
              Icons.account_balance_wallet_rounded,
              size: 40,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(top: 10.5),
            onPressed: () {},
            icon: Icon(
              Icons.home,
              size: 40,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(top: 10.5),
            onPressed: () {},
            icon: Icon(
              Icons.store,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
