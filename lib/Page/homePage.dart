import 'dart:convert';
import 'package:aol_mcc/Function/NavBar.dart';
import 'package:aol_mcc/Page/ProfilePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aol_mcc/Function/imageCarousel.dart';

import '../Function/user.dart';

class HomePage extends StatefulWidget {
  int UserID;
  HomePage({super.key, required this.UserID});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final int id;

  // void detailPressed(int id) {
    // var navigator = Navigator.of(context);
    // navigator.push(
    //   MaterialPageRoute(
    //     builder: (builder) {
    //       return ProfilePage(
    //         UserID: id,
    //       );
    //     },
    //   ),
    // );
  // }

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

  @override
  void initState() {
    super.initState();
    banbooList = fetchBanboo();
    id = widget.UserID;
  }

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
                builder: (context) => ProfilePage(
                  UserID: id,
                ),
              ),
            );

          },
          icon: const Icon(Icons.account_circle_rounded),
          color: const Color(0xFF333333),
          iconSize: 60,
          padding: const EdgeInsets.all(25),
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
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),

                  SizedBox(height: 10),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Text(
                        "Popular Art",
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: "Poppin",
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  const ImageCarousel(),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Text(
                        "All Banboos",
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: "Poppin",
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: banbooList,
                    builder: (context, snapshot) {
                      var data = snapshot.data;

                      if (data != null) {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 0.8),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            itemCount: data.length,
                            itemBuilder: ((context, index) {
                              final item = data[index];
                              return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ProductPage(
                                  //       banboo_id: banboo.banboo_id,
                                  //       price: banboo.price,
                                  //       account_id: id_,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                              width: 100,
                                              height: 100,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(Icons.error,
                                                    size: 50);
                                              },
                                            )
                                          : const Icon(Icons.image,
                                              size: 50, color: Colors.blue),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              );
                            }));
                      } else {
                        return const Text("data");
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          const Align(alignment: Alignment.bottomCenter, child: navBar()),
        ],
      ),
    );
  }
}
