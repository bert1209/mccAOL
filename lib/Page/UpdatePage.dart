import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Function/user.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
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
    // TODO: implement initState
    super.initState();
    banbooList = fetchBanboo();
  }

  File? image;

  Future pickImage(ImageSource source) async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var image = await pickedImage;
      var imageByte = await pickedImage.readAsBytes();
      var imagePreview = File(image.path);
      setState(() => this.image = imagePreview);

      setState(() {
        _ImageController = imageByte;
      });
    }
    ;
  }

  void _insertOnPressed(BuildContext context) async {
    if (_nameController.text == "" ||
        _HPController.text == "" ||
        _descriptionController.text == "" ||
        _ATKController.text == "" ||
        _DEFController.text == "" ||
        _ImpactController.text == "" ||
        _CRateController.text == "" ||
        _CDMGController.text == "" ||
        _PRatioController.text == "" ||
        _AnomMasterController.text == "" ||
        _RankController.text == "" ||
        _descriptionController == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All Fields Must be Filled!')));
    } else {
      // Insert to DB
      String url = "http://10.0.2.2:3000/banboos/insert-new-banboo-data";
      String json = jsonEncode({
        "BanbooName": _nameController.text,
        "BanbooHP": _HPController.text,
        "BanbooATK": _ATKController.text,
        "BanbooDEF": _DEFController.text,
        "BanbooImpact": _ImpactController.text,
        "BanbooCRate": _CRateController.text,
        "BanbooCDmg": _CDMGController.text,
        "BanbooPRatio": _PRatioController.text,
        "BanbooAMastery": _AnomMasterController.text,
        "BanbooRank": _RankController.text,
        "BanbooDescription": _descriptionController.text,
        "BanbooImage":
            _ImageController != null ? base64Encode(_ImageController!) : null,
      });

      final resp = await http.post(Uri.parse(url),
          headers: {"Content-type": "application/json"}, body: json);
      print(resp.statusCode);

      if (resp.statusCode == 200) {
        Navigator.pushNamed(context, '/adminHomePage');
      } else if (resp.statusCode == 400) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Insert Failed')));
      }
    }
  }

  var _nameController = TextEditingController();
  var _HPController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _ATKController = TextEditingController();
  var _DEFController = TextEditingController();
  var _ImpactController = TextEditingController();
  var _CRateController = TextEditingController();
  var _CDMGController = TextEditingController();
  var _PRatioController = TextEditingController();
  var _AnomMasterController = TextEditingController();
  var _RankController = TextEditingController();
  var _ImageControll = TextEditingController();
  Uint8List? _ImageController;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context)
        .size
        .height; //buat screen height tapi pake persentase dari screen
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFF777777),
        appBar: AppBar(
          toolbarHeight: 100,
          leading: IconButton(
            splashColor: Color(0xFF111111),
            onPressed: () {},
            icon: Icon(Icons.arrow_back_rounded),
            color: Color(0xFF333333),
            iconSize: 25,
            padding: EdgeInsets.all(25),
          ),
          title: const Text(
            "Banboo\n  Store",
            style: TextStyle(
              fontFamily: "Bangers",
              fontSize: 40,
              color: Color(0xFF333333),
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF999999),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            // Insert page ------------------------------------------------------------------------------------------------------------------------------
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: screenHeight * 0.33,
                    //color: Colors.green,
                    child: Center(
                      child: image != null
                          ? Image.file(image!)
                          : Transform.scale(
                              scale: 3,
                              child: Icon(
                                Icons.photo_library_rounded,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.32),
                      Container(
                        padding: const EdgeInsets.all(
                            30), // Padding inside the container
                        decoration: const BoxDecoration(
                          // warna border
                          color: Color(0xFF999999),

                          borderRadius: BorderRadius.only(
                              // lengkungan border
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),

                        child: Column(
                          children: [
                            const SizedBox(height: 25),
                            FutureBuilder(
                                future: banbooList,
                                builder: (Context, snapshot) {
                                  var data = snapshot.data;

                                  if (data != null) {
                                     return ListView.builder(
                                itemCount:
                                    data.length, // Jumlah item dalam data
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _nameController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Name'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);

                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _HPController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Health Point'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _ATKController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Attack'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _DEFController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Deffence'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _ImpactController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Impact'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _CRateController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Critical Rate'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _CDMGController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Critical Damage'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _PRatioController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label:
                                                      Text('Penetration Ratio'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _AnomMasterController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Anomaly Mastery'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _RankController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                  label: Text('Rank'),
                                                  filled: true,
                                                  fillColor: Color(0xFFFFFFFF),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      );
                                      const SizedBox(height: 30);
                                      TextField(
                                        maxLines: null,
                                        minLines: 5,
                                        maxLength: 500,
                                        controller: _descriptionController,
                                        decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: Text('Description'),
                                            filled: true,
                                            fillColor: Color(0xFFFFFFFF),
                                            border: OutlineInputBorder()),
                                      );
                                      const SizedBox(height: 50);
                                      Center(
                                        // Tombol Add Product
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _insertOnPressed(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(
                                                0xFF333333), // Change the background color
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 55, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ), // Add padding if needed
                                          ),
                                          child: const Text(
                                            'Add',
                                            style: TextStyle(
                                              fontFamily: 'SemiPoppins',
                                              fontSize: 16.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );

                                      const SizedBox(height: 40);
                                      return null;
                                  }, 
                                  );
                                }else {
                                    return const Text('data');
                                  }
                                }
                                )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: screenHeight * 0.288,
                    right: screenWidth *
                        0.1, // Adjust this to control spacing from the right edge
                    child: Transform.scale(
                      scale: 0.6,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(35),
                          ),
                          color: Color(0xFF333333),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            pickImage(ImageSource.gallery);
                            // var pickedImage = await ImagePicker()
                            //     .pickImage(source: ImageSource.gallery);
                            // if (pickedImage != null) {
                            //   var imageByte =
                            //       await pickedImage.readAsBytes();
                            //   setState(() {
                            //     _ImageController = imageByte;
                            //   });
                            // };
                          },
                          icon: const Icon(Icons.edit_rounded,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])));
  }
}
