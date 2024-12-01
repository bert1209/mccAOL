// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:aol_mcc/Function/MyTextField.dart';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Page/VerificationPage.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Function/user.dart';

class ProductPage extends StatefulWidget {
  int BanbooID;
  int UserID;
  int UserMoney;

  ProductPage({
    super.key,
    required this.BanbooID,
    required this.UserID,
    required this.UserMoney,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<banboo>> banbooList;

  Future<List<banboo>> fetchBanboo() async {
    String url = "http://10.0.2.2:3000/banboos/get-banboo-detail";
    String json = jsonEncode({
      "BanbooID": widget.BanbooID,
    });

    final resp = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json);
    print(resp.statusCode);
    var result = jsonDecode(resp.body);

    print(result);

    List<banboo> banbooList = [];

    for (var i in result) {
      banboo fetchBanboo = banboo.fromJson(i);
      banbooList.add(fetchBanboo);
    }

    return banbooList;
  }

  late Future<List<user>> userList;

  Future<List<user>> fetchUser() async {
    String url = "http://10.0.2.2:3000/banboos/get-user";
    String json = jsonEncode({
      "UserID": widget.UserID.toString(),
    });
    //var resp = await http.get(Uri.parse(url));
    final resp = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json);
    print(resp.statusCode);
    var result = jsonDecode(resp.body);

    print(result);

    List<user> userList = [];

    for (var i in result) {
      user fetchedUser = user.fromJson(i);
      userList.add(fetchedUser);
    }

    return userList;
  }

  @override
  void initState() {
    super.initState();
    userList = fetchUser();
    banbooList = fetchBanboo();
  }

  void onPressed(int money, int price) async {
    String url = "http://10.0.2.2:3000/banboos/checkout-banboo";
    String json = jsonEncode(
        {"price": price.toString(), "UserID": widget.UserID.toString()});

    final resp = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json);
    print(resp.statusCode);

    if (resp.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationPage(
            UserID: widget.UserID,
            UserMoney: widget.UserMoney,
            BanbooID: widget.BanbooID,
            Images: "lib/Assets/Success.png",
            Text1: "Success",
            Text2: "Transaction Completed Succsessfully",
          ),
        ),
      );
    } else if (resp.statusCode == 500) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationPage(
              UserID: widget.UserID,
              UserMoney: widget.UserMoney,
              BanbooID: widget.BanbooID,
              Images: "lib/Assets/Failed.png",
              Text1: "Error",
              Text2: "Transaction Has Failed"),
        ),
      );
    }
  }

  late int price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF777777),
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          splashColor: const Color(0xFF111111),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  UserID: widget.UserID,
                  UserMoney: widget.UserMoney,
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFF333333),
          iconSize: 30,
          padding: const EdgeInsets.only(left: 25),
        ),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: ' Banboo',
                style: TextStyle(
                  fontFamily: 'Bangers',
                  fontSize: 35,
                  color: Color(0xFF333333), // Original color for 'Banboo'
                ),
              ),
              TextSpan(
                text: '\n  Store',
                style: TextStyle(
                  fontFamily: 'Bangers',
                  fontSize: 35,
                  color: Colors.white, // White color for 'Store'
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF999999),
        actions: [
          FutureBuilder(
            future: userList,
            builder: (context, snapshot) {
              var data = snapshot.data;

              if (data != null) {
                return Column(
                    children: data
                        .map(
                          (e) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 19, top: 30, bottom: 10),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF333333),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Icon(
                                                  Icons.monetization_on_rounded,
                                                  size: 20,
                                                  color: Colors.white),
                                            ),
                                            TextSpan(
                                              text:
                                                  "  ${e.UserMoney.toString()}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: "Poppin",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList());
              } else {
                return const Text("error");
              }
            },
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: FutureBuilder(
                future: banbooList,
                builder: (context, snapshot) {
                  var data = snapshot.data;

                  if (data != null) {
                    return Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: data
                          .map(
                            (e) => Column(
                              children: [
                                const SizedBox(height: 40),
                                Container(
                                  height: 200,
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: Image.memory(
                                    base64Decode(e.BanbooImage),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Banboo ID : ",
                                      style: TextStyle(
                                        fontFamily: "Poppin",
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      e.BanbooID.toString(),
                                      style: const TextStyle(
                                        fontFamily: "Poppin",
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 15,
                                      ),
                                    ),
                                    // Text(widget.UserMoney.toString())
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  height: 500,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF999999),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 25),
                                      Row(
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 35)),
                                          Text(
                                            e.BanbooName,
                                            style: const TextStyle(
                                                fontFamily: "Poppin",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 40,
                                                color: Color(0xFF333333)),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "(${e.BanbooRank})",
                                            style: const TextStyle(
                                                fontFamily: "Poppin",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Color(0xFF333333)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 35),
                                          ),
                                          Container(
                                            width: 350,
                                            child: Text(
                                              e.BanbooDescription,
                                              style: const TextStyle(
                                                fontFamily: "Poppin",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Color(0xFF555555),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 25),
                                      Row(
                                        children: const [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 35)),
                                          Text(
                                            "Stats :",
                                            style: TextStyle(
                                                fontFamily: "Poppin",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Color(0xFF333333)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 45),
                                          ),
                                          Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: (Color(0xFF777777)),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 1,
                                                  color: Color(0xFF333333),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 80,
                                                      child: Text(
                                                        "HP",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ": ${e.BanbooHP.toString()}",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 80,
                                                      child: Text(
                                                        "ATK",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ": ${e.BanbooATK.toString()}",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 80,
                                                      child: Text(
                                                        "DEF",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ": ${e.BanbooDEF.toString()}",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 80,
                                                      child: Text(
                                                        "Impact",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ": ${e.BanbooImpact.toString()}",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: (Color(0xFF777777)),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 1,
                                                  color: Color(0xFF333333),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 90,
                                                      child: Text(
                                                        "Crit Rate",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ": ${e.BanbooCRate.toString()}%",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 90,
                                                      child: Text(
                                                        "Crit DMG",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ": ${e.BanbooCDmg.toString()}%",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 90,
                                                      child: Text(
                                                        "Pen Ratio",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ": ${e.BanbooPRatio.toString()}%",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 90,
                                                      child: Text(
                                                        "AMastery",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ": ${e.BanbooAMastery.toString()}",
                                                        style: TextStyle(
                                                          fontFamily: "Poppin",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.monetization_on_rounded,
                                            size: 40,
                                            color: Color(0xFF333333),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            e.BanbooPrice.toString(),
                                            style: TextStyle(
                                              fontFamily: "Poppin",
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          elevatedButtons(
                                            width: 100,
                                            height: 30,
                                            fontSize: 20,
                                            text: "Buy",
                                            textColor: Color(0xFFFFFFFF),
                                            buttonColor: Color(0xFF333333),
                                            onPressed: () => onPressed(
                                                widget.UserMoney,
                                                e.BanbooPrice),
                                            borderRadius: 5,
                                            FontType: "Poppin",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    return const Text("error");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
