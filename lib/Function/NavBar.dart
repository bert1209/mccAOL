import 'package:aol_mcc/Page/StorePage.dart';
import 'package:flutter/material.dart';

class navBar extends StatelessWidget {
  late final int UserID;
  navBar({super.key, required this.UserID});


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
        color: const Color(0xFF999999),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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
            padding: const EdgeInsets.only(top: 10.5),
            onPressed: () {},
            icon: const Icon(
              Icons.account_balance_wallet_rounded,
              size: 40,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(top: 10.5),
            onPressed: () {},
            icon: const Icon(
              Icons.home,
              size: 40,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(top: 10.5),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StorePage(
                    UserID: UserID,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.store,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
