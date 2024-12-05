import 'dart:convert';
import 'package:aol_mcc/Function/NavBar.dart';
import 'package:aol_mcc/Page/ProductPage.dart';
import 'package:aol_mcc/Page/ProfilePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aol_mcc/Function/imageCarousel.dart';

import '../Function/user.dart';

class HomePage extends StatefulWidget {
  int UserID;
  int UserMoney;
  HomePage({super.key, required this.UserID, required this.UserMoney});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final int id;

  late Future<List<banboo>> banbooList;

  Future<List<banboo>> fetchBanboo() async {
    String url = "http://10.0.2.2:3000/banboos/display-banboos-data";

    var resp = await http.get(Uri.parse(url));
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
    banbooList = fetchBanboo();
    userList = fetchUser();
    id = widget.UserID;
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height; //buat screen height tapi pake persentase dari screen
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Scaffold(
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
                    builder: (context) => ProfilePage(
                      UserID: id,
                      UserMoney: widget.UserMoney,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.person),
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
                                  left: 16, right: 20, top: 16, bottom: 0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: const Color(0xFF999999),
                                    borderRadius:
                                    BorderRadius.circular(15)),
                                child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                                Icons
                                                    .monetization_on_rounded,
                                                size: 20,
                                                color: Color(0xFF333333)),
                                          ),
                                          TextSpan(
                                            text:
                                            "  ${e.UserMoney.toString()}",
                                            style: const TextStyle(
                                                color: Color(0xFF333333),
                                                fontSize: 20,
                                                fontFamily: "Poppin",
                                                fontWeight:
                                                FontWeight.bold),
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
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          padding: const EdgeInsets.only(left: 18),
                          child: const Text("Popular Arts", style: TextStyle(fontFamily: 'Poppin', color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 35),)
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    const ImageCarousel(),

                    SizedBox(height: screenHeight * 0.035),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          padding: const EdgeInsets.only(left: 18),
                          child: const Text("All Banboos", style: TextStyle(fontFamily: 'Poppin', color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 35),)
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: FutureBuilder(
                        future: banbooList,
                        builder: (context, snapshot) {
                          var data = snapshot.data;

                          if (data != null) {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      childAspectRatio: 0.82),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              //padding: const EdgeInsets.all(1),
                              itemCount: data.length,
                              itemBuilder: ((context, index) {
                                final item = data[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductPage(
                                          BanbooID: item.BanbooID,
                                          UserID: widget.UserID,
                                          UserMoney: widget.UserMoney,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        item.BanbooImage.isNotEmpty
                                            ? Image.memory(
                                                base64Decode(item.BanbooImage),
                                                width: 135,
                                                height: 135,
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                  return const Icon(Icons.error,
                                                      size: 50);
                                                },
                                              )
                                            : const Icon(Icons.image,
                                                size: 50, color: Colors.blue),
                                        const SizedBox(height: 1),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          } else {
                            return const Text("data");
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 90)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: navBar(
                UserID: id,
                UserMoney: widget.UserMoney,
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
