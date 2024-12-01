import 'dart:convert';
import 'package:aol_mcc/Page/ValidationPage.dart';
import 'package:aol_mcc/Page/VerificationPage.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Function/user.dart';

class TopUpPage extends StatefulWidget {
  int UserID;
  int UserMoney;
  TopUpPage({super.key, required this.UserID, required this.UserMoney});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
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
  }

  void onPressed(int id) async {
    String url = "http://10.0.2.2:3000/banboos/update-user-money";
    String json = jsonEncode({"money": id.toString(), "UserID": widget.UserID});

    final resp = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json);
    print(resp.statusCode);

    if (resp.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValidationPage(
              UserID: widget.UserID,
              UserMoney: widget.UserMoney,
              Images: "lib/Assets/Success.png",
              Text1: "Success",
              Text2: "TopUp Completed Successfuly"),
        ),
      );
    } else if (resp.statusCode == 500) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValidationPage(
              UserID: widget.UserID,
              UserMoney: widget.UserMoney,
              Images: "lib/Assets/Failed.png",
              Text1: "Error",
              Text2: "TopUp Has Failed"),
        ),
      );
    }
  }

  var money = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.only(left: 40),
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
        actions: const [
          //Wallet()
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              FutureBuilder(
                future: userList,
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
                                const SizedBox(height: 75),
                                const Align(alignment: Alignment.center),
                                Container(
                                  height: 100,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF999999),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 45),
                                      const Icon(
                                        Icons.monetization_on_rounded,
                                        size: 40,
                                        color: Color(0xFF333333),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        e.UserMoney.toString(),
                                        style: const TextStyle(
                                          fontFamily: "Poppin",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 125),
                                Row(
                                  children: [
                                    SizedBox(width: 16.5),
                                    GestureDetector(
                                      onTap: () => onPressed(100),
                                      child: Container(
                                        height: 150,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF999999),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: const [
                                            SizedBox(height: 40),
                                            Align(alignment: Alignment.center),
                                            Icon(
                                              Icons.monetization_on_rounded,
                                              size: 40,
                                              color: Color(0xFF333333),
                                            ),
                                            Text(
                                              "100",
                                              style: TextStyle(
                                                fontFamily: "Poppin",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => onPressed(300),
                                      child: Container(
                                        height: 150,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF999999),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: const [
                                            SizedBox(height: 40),
                                            Align(alignment: Alignment.center),
                                            Icon(
                                              Icons.monetization_on_rounded,
                                              size: 40,
                                              color: Color(0xFF333333),
                                            ),
                                            Text(
                                              "300",
                                              style: TextStyle(
                                                fontFamily: "Poppin",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => onPressed(500),
                                      child: Container(
                                        height: 150,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF999999),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: const [
                                            SizedBox(height: 40),
                                            Align(alignment: Alignment.center),
                                            Icon(
                                              Icons.monetization_on_rounded,
                                              size: 40,
                                              color: Color(0xFF333333),
                                            ),
                                            Text(
                                              "500",
                                              style: TextStyle(
                                                fontFamily: "Poppin",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                          ],
                                        ),
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
            ],
          ),
        ],
      ),
    );
  }
}
