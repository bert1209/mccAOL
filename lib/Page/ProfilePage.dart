import 'dart:convert';
import 'package:aol_mcc/Function/googleAuth.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    String url = "http://10.0.2.2:3000/user/get-user";
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
                signOutGoogle();
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
                  height: screenHeight * 0.33, // Set desired height
                  fit: BoxFit.cover, // Adjust how the image scales
                ),

                //const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.only(top: 15, right: 40, left: 15), // Padding inside the container
                  decoration: const BoxDecoration(
                    // warna border
                    color: Color(0xFF333333),

                    borderRadius: BorderRadius.only(
                      // lengkungan border
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  width: screenWidth * 1,
                  height: 140,
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
                            (e) =>
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  e.Username,
                                  style: const TextStyle(
                                    fontFamily: "Poppin",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    color: Color(0xFF999999),
                                  ),
                                  maxLines: 1,
                                  minFontSize: 33,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    // Flexible ensures the email takes only as much space as it needs without pushing the RichText.
                                    Flexible(
                                      child: AutoSizeText(
                                        e.Email,
                                        style: const TextStyle(
                                          fontFamily: "SemiPoppins",
                                          fontSize: 22,
                                          color: Color(0xFF999999),
                                        ),
                                        maxLines: 1,
                                        minFontSize: 22, // Reduce the font size if necessary
                                        overflow: TextOverflow.ellipsis, // Truncates the email if it's too long
                                      ),
                                    ),
                                    // Add spacing between the email and RichText, if necessary
                                    const SizedBox(width: 5),
                                    // RichText stays next to the email
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: " -",
                                            style: TextStyle(
                                              fontFamily: "SemiPoppins",
                                              fontSize: 22,
                                              color: Color(0xFF999999),
                                            ),
                                          ),
                                          TextSpan(
                                            text: widget.UserID.toString(),
                                            style: const TextStyle(
                                              fontFamily: "SemiPoppins",
                                              fontSize: 22,
                                              color: Color(0xFF999999),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )

                              ],
                            )
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
                          color: Color(0xFFEFEFEF),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(
                            child: Text(
                              "Bangboo, the spirited mascot of Banboo Store, turns every shopping trip into a comedy show. Need a phone case? He’s juggling three. Checking out a laptop? He’s using it as a surfboard. Lovable and chaotic, he’s the unexpected highlight of every visit!",
                              style: TextStyle(
                                fontFamily: "SemiPoppins",
                                color: Color(0xFFEFEFEF),
                                fontSize: 17,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.clip,
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Icon(
                            Icons.store,
                            color: Color(0xFFEFEFEF),
                            size: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Store_BanbooID",
                            style: TextStyle(
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFFEFEFEF),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: const [
                          Icon(
                            Icons.facebook,
                            color: Color(0xFFEFEFEF),
                            size: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Store_BanbooID",
                            style: TextStyle(
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFFEFEFEF),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Image.asset(
                            "lib/Assets/instagram.png",
                            height: 35,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Store_BanbooID",
                            style: TextStyle(
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFFEFEFEF),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Image.asset(
                            "lib/Assets/youtube.png",
                            height: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Store_BanbooID",
                            style: TextStyle(
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFFEFEFEF),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.15),
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
