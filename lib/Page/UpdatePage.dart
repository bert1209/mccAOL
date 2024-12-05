import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Function/user.dart';

class UpdatePage extends StatefulWidget {
  int id;
  String name;
  int hp;
  int atk;
  int def;
  int impact;
  int crate;
  int cdmg;
  int pratio;
  int amaster;
  String rank;
  Uint8List? image;
  String desc;
  int price;
  int level;

  UpdatePage(
      {super.key,
      required this.id,
      required this.name,
      required this.hp,
      required this.atk,
      required this.def,
      required this.impact,
      required this.crate,
      required this.cdmg,
      required this.pratio,
      required this.amaster,
      required this.rank,
      required this.image,
      required this.desc,
      required this.price,
      required this.level});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  File? image;

  Future pickImage(ImageSource source) async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var image = pickedImage;
      var imageByte = await pickedImage.readAsBytes();
      var imagePreview = File(image.path);
      setState(() => this.image = imagePreview);

      setState(() {
        _ImageController = imageByte;
      });
    }
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
        _descriptionController == "" ||
        _PriceController == "" ||
        _LevelController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All Fields Must be Filled!')));
    } else {
      // Insert to DB
      String url = "http://10.0.2.2:3000/banboos/update-banboos-data";
      String json = jsonEncode({
        "BanbooID": widget.id.toString(),
        "BanbooName": _nameController.text,
        "BanbooHP": _HPController.text.toString(),
        "BanbooATK": _ATKController.text.toString(),
        "BanbooDEF": _DEFController.text.toString(),
        "BanbooImpact": _ImpactController.text.toString(),
        "BanbooCRate": _CRateController.text.toString(),
        "BanbooCDmg": _CDMGController.text.toString(),
        "BanbooPRatio": _PRatioController.text.toString(),
        "BanbooAMastery": _AnomMasterController.text.toString(),
        "BanbooRank": _RankController.text,
        "BanbooDescription": _descriptionController.text,
        "BanbooImage":
            _ImageController != null ? base64Encode(_ImageController!) : null,
        "BanbooPrice": _PriceController.text.toString(),
        "BanbooLevel": _LevelController.text.toString(),
      });

      final resp = await http.post(Uri.parse(url),
          headers: {"Content-type": "application/json"}, body: json);
      print(resp.statusCode);

      if (resp.statusCode == 200) {
        Navigator.pushNamed(context, '/insertPage');
      } else if (resp.statusCode == 400) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Update Failed')));
      }
    }
  }

  final _nameController = TextEditingController();
  final _HPController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ATKController = TextEditingController();
  final _DEFController = TextEditingController();
  final _ImpactController = TextEditingController();
  final _CRateController = TextEditingController();
  final _CDMGController = TextEditingController();
  final _PRatioController = TextEditingController();
  final _AnomMasterController = TextEditingController();
  final _RankController = TextEditingController();
  final _ImageControll = TextEditingController();
  Uint8List? _ImageController;
  final _PriceController = TextEditingController();
  final _LevelController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.name;
    _HPController.text = widget.hp.toString();
    _descriptionController.text = widget.desc;
    _ATKController.text = widget.atk.toString();
    _DEFController.text = widget.def.toString();
    _ImpactController.text = widget.impact.toString();
    _CRateController.text = widget.crate.toString();
    _CDMGController.text = widget.cdmg.toString();
    _PRatioController.text = widget.pratio.toString();
    _AnomMasterController.text = widget.amaster.toString();
    _RankController.text = widget.rank;
    _ImageController = widget.image;
    _PriceController.text = widget.price.toString();
    _LevelController.text = widget.level.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context)
        .size
        .height; //buat screen height tapi pake persentase dari screen
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF777777),
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          splashColor: const Color(0xFF111111),
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFF333333),
          iconSize: 25,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  SizedBox(
                    height: screenHeight * 0.33,
                    //color: Colors.green,
                    child: Center(
                      child: image != null
                          ? Image.memory(_ImageController!)
                          : Transform.scale(
                              scale: 3,
                              child: const Icon(
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
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Name'),
                                      filled: true,
                                      fillColor: const Color(0xfffffffff),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _HPController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Health Point'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _ATKController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Attack'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _DEFController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Deffence'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _ImpactController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Impact'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _CRateController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Critical Rate'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _CDMGController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Critical Damage'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _PRatioController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Penetration Ratio'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _AnomMasterController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Anomaly Mastery'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _PriceController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Price'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _RankController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      label: const Text('Rank'),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFFFF),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            TextField(
                              maxLines: null,
                              minLines: 5,
                              maxLength: 500,
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                label: const Text('Description'),
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Center(
                              // Tombol Add Product
                              child: ElevatedButton(
                                onPressed: () => _insertOnPressed(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xFF333333), // Change the background color
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 55, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ), // Add padding if needed
                                ),
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                    fontFamily: 'SemiPoppins',
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
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
                          },
                          icon: const Icon(Icons.edit_rounded,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Insert page ------------------------------------------------------------------------------------------------------------------------------
            ),
          ],
        ),
      ),
    );
  }
}
