import 'dart:convert';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Function/NavBar.dart';
import '../Function/user.dart';

class ProfilePage extends StatefulWidget {
  int UserID;
  int UserMoney;

  ProfilePage({super.key, required this.UserID, required this.UserMoney});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

var idController = TextEditingController();

class _ProfilePageState extends State<ProfilePage> {
  var idController = TextEditingController();

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
    idController.text = widget.UserID.toString();
  }

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
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/authPage');
              },
              icon: Icon(Icons.logout)),
          Padding(padding: EdgeInsets.only(right: 15))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("lib/Assets/GambarProfilePage.png"),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.only(right: 60, left: 10),
                  child: FutureBuilder(
                    future: userList,
                    builder: (context, snapshot) {
                      var data = snapshot.data;

                      if (data != null) {
                        return Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: data
                              .map(
                                (e) => RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: e.Username,
                                        style: const TextStyle(
                                          fontFamily: "Poppin",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40,
                                        ),
                                      ),
                                      const TextSpan(text: "\n"),
                                      TextSpan(
                                        text: e.Email,
                                        style: const TextStyle(
                                          fontFamily: "Poppin",
                                          fontSize: 20,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " - ",
                                        style: TextStyle(
                                          fontFamily: "Poppin",
                                          fontSize: 20,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.UserID.toString(),
                                        style: const TextStyle(
                                          fontFamily: "Poppin",
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  ),
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
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.only(left: 25),
                  color: const Color(0xFF333333),
                  height: 420,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "About",
                        style: TextStyle(
                          fontFamily: "Poppin",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Bangboo, the spirited mascot of Banboo Store, \nturns every shopping trip into a comedy \nshow. Need a phone case? He’s juggling three. \nChecking out a laptop? He’s using it as a surfboard. \nLovable and chaotic, he’s the unexpected \nhighlight of every visit!",
                            style: TextStyle(
                                fontFamily: "Poppin", color: Color(0xFFFFFFFF)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Icon(
                            Icons.store,
                            color: Color(0xFFFFFFFF),
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Store_BanbooID",
                            style: TextStyle(
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.facebook,
                            color: Color(0xFFFFFFFF),
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Store_BanbooID",
                            style: TextStyle(
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "lib/Assets/instagram.png",
                            height: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Store_BanbooID",
                            style: TextStyle(
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "lib/Assets/youtube.png",
                            height: 21.5,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Store_BanbooID",
                            style: TextStyle(
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: navBar(
                UserID: widget.UserID,
                UserMoney: widget.UserMoney,
              )),
        ],
      ),
    );
  }
}
