// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Page/VerificationPage.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:aol_mcc/Page/TopUpPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Function/AuthService.dart';
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
    String url = "http://10.0.2.2:3000/banboo/get-banboo-detail";
    String json = jsonEncode({
      "BanbooID": widget.BanbooID,
    });
    var token = AuthService.loggedUser!.token;
    final resp = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json", "token": token},
        body: json);
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
    String url = "http://10.0.2.2:3000/banboo/get-user";
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
    String url = "http://10.0.2.2:3000/banboo/checkout-banboo";
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF777777),
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: const Color(0xFF333333),
        leading: Container(
          decoration: BoxDecoration(
              color: const Color(0xFF999999),
              borderRadius: BorderRadius.circular(15)),

          margin: const EdgeInsets.fromLTRB(
              16, 20, 0, 20), // Adds 16px space on the left
          child: IconButton(
            color: const Color(0xFF333333),
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
          ),
        ),
        title: Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Banboo\n',
                  style: TextStyle(
                    fontFamily: 'Bangers',
                    fontSize: 30,
                    color: Color(0xFF999999), // Original color for 'Banboo'
                  ),
                ),
                TextSpan(
                  text: 'Store',
                  style: TextStyle(
                    fontFamily: 'Bangers',
                    fontSize: 30,
                    color: Color(0xFFEFEFEF), // White color for 'Store'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child:
            FutureBuilder(
              future: banbooList,
              builder: (context, snapshot) {
                var data = snapshot.data;

                if (data != null) {
                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: data
                        .map(
                          (e) => Stack(
                        children: [
                          SizedBox(height: 25),
                          Container(

                            height: screenHeight * 0.35,
                            alignment: Alignment.center,
                            child: Image.memory(
                              base64Decode(e.BanbooImage),
                              height: screenHeight * 0.35,
                              width: screenWidth * 0.35,
                            ),
                          ),

                          Positioned(
                            top: screenHeight * 0.295,
                            left: screenWidth * 0.05,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Banboo ID : ",
                                  style: TextStyle(
                                    fontFamily: "Poppin",
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEFEFEF),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  e.BanbooID.toString(),
                                  style: const TextStyle(
                                    fontFamily: "Poppin",
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEFEFEF),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            top: screenHeight * 0.293,
                            right: screenWidth * 0.05,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                e.Element != null && e.Element == 'Fire' ? Image.asset('lib/Assets/fire.png', height: 25, width: 25) : Text(''),
                                e.Element != null && e.Element == 'ICE' ? Image.asset('lib/Assets/ice.png', height: 25, width: 25) : Text(''),
                                e.Element != null && e.Element == 'Physical' ? Image.asset('lib/Assets/physical.png', height: 25, width: 25) : Text(''),
                                e.Element != null && e.Element == 'Ether' ? Image.asset('lib/Assets/ether.png', height: 25, width: 25) : Text(''),
                                e.Element != null && e.Element == 'Electric' ? Image.asset('lib/Assets/electric.png', height: 25, width: 25) : Text(''),

                                SizedBox(width: 5),

                                Text(
                                  e.Element,
                                  style: const TextStyle(
                                    fontFamily: "Poppin",
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEFEFEF),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              SizedBox(height: screenHeight * 0.33),
                              Container(
                                width: screenWidth * 1,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF333333),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: screenHeight * 0.035),
                                    Row(
                                      children: [
                                        const Padding(
                                            padding:
                                            EdgeInsets.only(left: 25)),
                                        Text(
                                          e.BanbooName,
                                          style: const TextStyle(
                                              fontFamily: "Poppin",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                              color: Color(0xFF999999)),
                                        ),
                                        SizedBox(width: screenWidth * 0.03),
                                        Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Color(0xFF999999),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${e.BanbooRank}",
                                              style: const TextStyle(
                                                  fontFamily: "Poppin",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30,
                                                  color: Color(0xFF333333)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 25),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.8,
                                          child: Text(
                                            e.BanbooDescription,
                                            style: const TextStyle(
                                              fontFamily: "SemiPoppins",
                                              fontSize: 18,
                                              color: Color(0xFF999999),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.035),


                                    Container(
                                      width: screenWidth * 1,
                                      color: Color(0xFF777777),
                                        child: Column(
                                          children: [
                                            SizedBox(height: screenHeight * 0.035),
                                            Row(
                                              children: const [
                                                Padding(
                                                    padding:
                                                    EdgeInsets.only(left: 25)),
                                                Text(
                                                  "Stats :",
                                                  style: TextStyle(
                                                      fontFamily: "Poppin",
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 30,
                                                      color: Color(0xFFEFEFEF)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: screenHeight * 0.01),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFF333333),
                                              ),
                                              width: screenWidth * 0.9,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 25),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      "Health Point",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFEFEFEF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      ": ${e.BanbooHP.toString()}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: screenHeight * 0.01),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFF333333),
                                              ),
                                              width: screenWidth * 0.9,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 25),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      "Attack",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      ": ${e.BanbooATK.toString()}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: screenHeight * 0.01),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFF333333),
                                              ),
                                              width: screenWidth * 0.9,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 25),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      "Defence",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      ": ${e.BanbooDEF.toString()}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: screenHeight * 0.01),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFF333333),
                                              ),
                                              width: screenWidth * 0.9,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 25),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      "Impact",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      ": ${e.BanbooImpact.toString()}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: screenHeight * 0.01),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFF333333),
                                              ),

                                              width: screenWidth * 0.9,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 25),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      "Critical Rate",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      ": ${e.BanbooCRate.toString()}%",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: screenHeight * 0.01),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFF333333),
                                              ),
                                              width: screenWidth * 0.9,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 25),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      "Critical Damage",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      ": ${e.BanbooCDmg.toString()}%",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: screenHeight * 0.01),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFF333333),
                                              ),
                                              width: screenWidth * 0.9,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 25),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      "Penetration Ratio",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      ": ${e.BanbooDEF.toString()}%",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: screenHeight * 0.01),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFF333333),
                                              ),
                                              width: screenWidth * 0.9,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 25),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      "Anomaly Mastery",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      ": ${e.BanbooImpact.toString()}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "Poppin",
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                            0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: screenHeight * 0.15)
                                          ],
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
          Align(
              alignment: Alignment.bottomCenter,
              child:
              Container(
                width: screenWidth * 1,
                height: screenHeight * 0.1,
                color: Color(0xFF333333),
                child: FutureBuilder(
                    future: banbooList,
                    builder: (context, snapshot) {
                      var data = snapshot.data;

                      if(data != null){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: data.map((e) =>
                              Row(
                                children: [
                                  SizedBox(width: 40,),
                                  Icon(
                                    Icons.monetization_on_rounded,
                                    size: 35,
                                    color: Color(0xFFEFEFEF),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    e.BanbooPrice.toString(),
                                    style: TextStyle(
                                      fontFamily: "Poppin",
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEFEFEF),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.3),
                                  elevatedButtons(
                                    fontWeight: FontWeight.bold,
                                    width: 100,
                                    height: 40,
                                    fontSize: 20,
                                    text: "Buy",
                                    textColor: Color(0xFFEFEFEF),
                                    buttonColor: Color(0xFF555555),
                                    onPressed: () => onPressed(
                                        widget.UserMoney,
                                        e.BanbooPrice),
                                    borderRadius: 5,
                                    FontType: "SemiPoppins",
                                  ),
                                ],
                              ),
                          )
                              .toList(),
                        );
                      } else {
                        return const Text("error");
                      }
                    }
                ),
              )
          ),
        ],
      )
    );
  }
}
