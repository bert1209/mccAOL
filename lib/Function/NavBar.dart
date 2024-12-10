import 'package:aol_mcc/Page/StorePage.dart';
import 'package:aol_mcc/Page/TopUpPage.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:flutter/material.dart';

class navBar extends StatelessWidget {
  late final int UserID;
  late final int UserMoney;
  navBar({
    super.key,
    required this.UserID,
    required this.UserMoney,

  });

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
        color: const Color(0xFF333333),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopUpPage(
                    UserID: UserID,
                    UserMoney: UserMoney,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.account_balance_wallet_rounded,
              size: 35,
              color: Color(0xFF999999)
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(top: 10.5),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    UserID: UserID,
                    UserMoney: UserMoney,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.home_rounded,
              size: 35,
              color: Color(0xFF999999)
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
                    UserMoney: UserMoney,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_rounded,
              size: 35,
              color: Color(0xFF999999)
            ),
          ),
        ],
      ),
    );
  }
}
