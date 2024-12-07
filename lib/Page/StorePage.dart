import 'dart:convert';
import 'package:aol_mcc/Page/ProductPage.dart';
import 'package:aol_mcc/Page/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Function/AuthService.dart';
import '../Function/NavBar.dart';
import '../Function/elevatedButtons.dart';
import '../Function/user.dart';

class StorePage extends StatefulWidget {
  final int UserID;
  final int UserMoney;
  const StorePage({
    super.key,
    required this.UserID,
    required this.UserMoney,
  });

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  var searchController = TextEditingController();

  late Future<List<banboo>> banbooList;

  Future<List<banboo>> fetchBanboo() async {
    if (searchController.text == "") {
      String url = "http://10.0.2.2:3000/banboo/display-banboos-data";
      var token = AuthService.loggedUser!.token;
      // ignore: avoid_print
      print(token);
      var resp = await http.get(Uri.parse(url), headers: {"token": token});
      var result = jsonDecode(resp.body);

      print(result);

      List<banboo> banbooList = [];

      for (var i in result) {
        banboo fetchBanboo = banboo.fromJson(i);
        banbooList.add(fetchBanboo);
      }

      return banbooList;

      //return banbooList
    } else if (searchController.text != "") {
      String url =
          "http://10.0.2.2:3000/banboo/search/${Uri.encodeComponent(searchController.text)}";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => banboo.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Error();
    }
  }

  @override
  void initState() {
    super.initState();
    banbooList = fetchBanboo();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF777777),
      appBar: AppBar(
        toolbarHeight: 80,
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
                fetchBanboo();
                setState(() {});
              },
              icon: const Icon(Icons.search_rounded),
              color: Color(0xFF333333), // Change icon color if needed
            ),
          ),
        ],
        title: Container(
          padding: const EdgeInsets.only(
            top: 11,
          ),
          width: 375,
          height: 70,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFF777777),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF333333),
                  ),
                  borderRadius: BorderRadius.circular(30)),
              fillColor: const Color(0xFFFFFFFF),
              filled: true,
              hintText: "Search",
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // height: 2200,
                  padding: const EdgeInsets.only(
                    top: 30,
                    right: 30,
                    left: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xff777777),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: FutureBuilder(
                    future: fetchBanboo(),
                    builder: (context, snapshot) {
                      var data = snapshot.data;

                      if (data != null) {
                        return ListView.builder(
                          shrinkWrap: true, // Menyesuaikan tinggi dengan isi
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              snapshot.data!.length, // Jumlah item dalam data
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 9,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF999999),
                                    border: Border.all(
                                      color: const Color(0xFF333333),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                      leading: Image.memory(
                                        base64Decode(item.BanbooImage),
                                        height: 100,
                                      ),
                                      title: Text(
                                        item.BanbooName,
                                        style: const TextStyle(
                                          fontFamily: "Poppin",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Price : ${item.BanbooPrice}',
                                        style: const TextStyle(
                                          fontFamily: "Poppin",
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      trailing: elevatedButtons(
                                          fontWeight: FontWeight.bold,
                                          width: 70,
                                          height: 30,
                                          fontSize: 10,
                                          text: "Buy",
                                          textColor: const Color(0xFFFFFFFF),
                                          buttonColor: const Color(0xFF333333),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductPage(
                                                  BanbooID: item.BanbooID,
                                                  UserID: widget.UserID,
                                                  UserMoney: widget.UserMoney,
                                                ),
                                              ),
                                            );
                                          },
                                          borderRadius: 10,
                                          FontType: "Poppin")),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Text("");
                      }
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.15),
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
