// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:aol_mcc/Page/ValidationPage.dart';
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
              Text2: "9999 Limit is Reached"),
        ),
      );
    }
  }

  var money = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height; //buat screen height tapi pake persentase dari screen
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF777777),
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: const Color(0xFF333333),
        leading: Container(
          decoration: BoxDecoration(
              color: const Color(0xFF999999),
              borderRadius: BorderRadius.circular(15)
          ),

          margin: const EdgeInsets.fromLTRB(16, 20, 0, 20), // Adds 16px space on the left
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
        title:
        Container(

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
                            (e) => Stack(
                          children: [

                            Column(
                              children: [


                                Container(
                                  height: screenHeight * 0.25,
                                  color: Color(0xFF333333),
                                  child:
                                  Column(
                                    children: [
                                      SizedBox(height: screenHeight * 0.085),

                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            padding: const EdgeInsets.only(left: 18),
                                            child: const Text("My Wallet :", style: TextStyle(fontFamily: 'Poppin', color: Color(0xFFEFEFEF), fontWeight: FontWeight.bold, fontSize: 35),)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.11),

                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      padding: const EdgeInsets.only(left: 18),
                                      child: const Text("Top Up Amount :", style: TextStyle(fontFamily: 'Poppin', color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 35),)
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.01),

                                Row(
                                  children: [
                                    const SizedBox(width: 16.5),
                                    GestureDetector(
                                      onTap: () => onPressed(100),
                                      child: Container(
                                        height: 150,
                                        width: 110,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF999999),
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2), // Shadow color with transparency
                                              spreadRadius: 2, // How much the shadow spreads
                                              blurRadius: 8, // How soft the shadow is
                                              offset: Offset(0, 4), // Position of the shadow (x, y)
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset("lib/Assets/moneybag.png", width: 80, height: 80),
                                            const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 40),
                                                Align(alignment: Alignment.center),
                                                Icon(
                                                  Icons.monetization_on_rounded,
                                                  size: 35,
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => onPressed(300),
                                      child: Container(
                                        height: 150,
                                        width: 110,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF999999),
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2), // Shadow color with transparency
                                              spreadRadius: 2, // How much the shadow spreads
                                              blurRadius: 8, // How soft the shadow is
                                              offset: Offset(0, 4), // Position of the shadow (x, y)
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset("lib/Assets/moneybag.png", width: 80, height: 80),
                                            const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 40),
                                                Align(alignment: Alignment.center),
                                                Icon(
                                                  Icons.monetization_on_rounded,
                                                  size: 35,
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => onPressed(500),
                                      child: Container(
                                        height: 150,
                                        width: 110,

                                        decoration: BoxDecoration(
                                          color: const Color(0xFF999999),
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2), // Shadow color with transparency
                                              spreadRadius: 2, // How much the shadow spreads
                                              blurRadius: 8, // How soft the shadow is
                                              offset: Offset(0, 4), // Position of the shadow (x, y)
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset("lib/Assets/moneybag.png", width: 80, height: 80),
                                            const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 40),
                                                Align(alignment: Alignment.center),
                                                Icon(
                                                  Icons.monetization_on_rounded,
                                                  size: 35,
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                                top: screenHeight * 0.18,
                                left: screenWidth * 0.125,
                                child:
                                Container(
                                  width: screenWidth * 0.75,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF999999), // Background color
                                    borderRadius: BorderRadius.circular(12), // Rounded corners (optional)
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2), // Shadow color with transparency
                                        spreadRadius: 2, // How much the shadow spreads
                                        blurRadius: 8, // How soft the shadow is
                                        offset: Offset(0, 4), // Position of the shadow (x, y)
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: screenHeight * 0.017),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 30),
                                          child: const Text(
                                            "Remaining Balance",
                                            style: TextStyle(
                                              fontFamily: 'SemiPoppins',
                                              color: Color(0xFF444444),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.001),
                                      Row(
                                        children: [
                                          SizedBox(width: 30),
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
                                              fontSize: 35,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.017),
                                    ],
                                  ),
                                )

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
