import 'dart:convert';
import 'package:aol_mcc/Page/homePage.dart';
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
    final screenHeight = MediaQuery.of(context).size.height; //buat screen height tapi pake persentase dari screen
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

        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 16, 20),
            width: 40, // Set width
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF999999),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/authPage');
              },
              icon: const Icon(Icons.logout),
              color: Color(0xFF333333), // Change icon color if needed
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "lib/Assets/GambarProfilePage.png",
                  width: screenWidth * 1, // Set desired width
                  height: screenHeight * 0.32, // Set desired height
                  fit: BoxFit.cover, // Adjust how the image scales
                ),

                //const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.only(top: 15, right: 40), // Padding inside the container
                  decoration: const BoxDecoration(
                    // warna border
                    color: Color(0xFF555555),

                    borderRadius: BorderRadius.only(
                      // lengkungan border
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  width: screenWidth * 1,
                  height: screenHeight * 0.2,
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
                                          fontFamily: "SemiPoppins",
                                          fontSize: 20,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " - ",
                                        style: TextStyle(
                                          fontFamily: "SemiPoppins",
                                          fontSize: 20,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.UserID.toString(),
                                        style: const TextStyle(
                                          fontFamily: "SemiPoppins",
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
                  color: const Color(0xFF777777),
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
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bangboo, the spirited mascot of Banboo Store, \nturns every shopping trip into a comedy \nshow. Need a phone case? He’s juggling three. \nChecking out a laptop? He’s using it as a surfboard. \nLovable and chaotic, he’s the unexpected \nhighlight of every visit!",
                            style: TextStyle(
                                fontFamily: "SemiPoppins", color: Color(0xFFFFFFFF)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
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
                      const Row(
                        children: [
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
