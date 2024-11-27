import 'dart:convert';
import 'package:aol_mcc/Function/elevatedButtons.dart';
import 'package:aol_mcc/Page/UpdatePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:aol_mcc/Function/user.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPage();
}

class _InsertPage extends State<InsertPage> {
  void detailPressed(
    int id,
    String name,
    int hp,
    int atk,
    int def,
    int impact,
    int crate,
    int cdmg,
    int pratio,
    int amaster,
    String rank,
    Uint8List? image,
    String desc,
    int price,
    int level,
  ) {
    var navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (builder) {
          return UpdatePage(
            id: id,
            name: name,
            hp: hp,
            atk: atk,
            def: def,
            impact: impact,
            crate: crate,
            cdmg: cdmg,
            pratio: pratio,
            amaster: amaster,
            rank: rank,
            desc: desc,
            image: image,
            price: price,
            level: level,
          );
        },
      ),
    );
  }

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

  Future _deleteOnPressed(int id) async {
    String url = "http://10.0.2.2:3000/banboos/delete-banboos";
    var resp = await http.delete(Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"BanbooID": id}));

    if (resp.statusCode == 200) {
      setState(() {
        banbooList = fetchBanboo();
      });
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
  var _PriceController = TextEditingController();
  var _LevelController = TextEditingController();

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
        _ImageController == "" || 
        _LevelController == "") {
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
        "BanbooPrice": _PriceController.text,
        "BanbooLevel": _LevelController.text,
      });

      final resp = await http.post(Uri.parse(url),
          headers: {"Content-type": "application/json"}, body: json);
      print(resp.statusCode);

      if (resp.statusCode == 200) {
        Navigator.pushNamed(context, '/adminVerif');
      } else if (resp.statusCode == 400) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Insert Failed')));
      }
    }
  }

  // level: 1 - 70;
  @override
  // sign / home / catalog / deskripsi / admin / user
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context)
        .size
        .height; //buat screen height tapi pake persentase dari screen
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xFF777777),
            bottom: const TabBar(tabs: [
              Tab(
                child: Text(
                  'Insert',
                  style:
                      TextStyle(fontFamily: 'SemiPoppins', color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Update',
                  style:
                      TextStyle(fontFamily: 'SemiPoppins', color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Delete',
                  style:
                      TextStyle(fontFamily: 'SemiPoppins', color: Colors.white),
                ),
              )
            ]),
            leading: Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: IconButton(
                  color: const Color(0xFF333333),
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_rounded)),
            ),
            actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/authPage');
              },
              icon: Icon(Icons.logout)),
          Padding(padding: EdgeInsets.only(right: 15))
        ],
            title: Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Banboo ',
                      style: TextStyle(
                        fontFamily: 'Bangers',
                        fontSize: 22,
                        color: Color(0xFF333333), // Original color for 'Banboo'
                      ),
                    ),
                    TextSpan(
                      text: 'Store',
                      style: TextStyle(
                        fontFamily: 'Bangers',
                        fontSize: 22,
                        color: Colors.white, // White color for 'Store'
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: const Text('Name'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: const Text('Health Point'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: const Text('Attack'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: const Text('Deffence'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: const Text('Impact'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: const Text('Critical Rate'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label:
                                                const Text('Critical Damage'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label:
                                                const Text('Penetration Ratio'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label:
                                                const Text('Anomaly Mastery'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: const Text('Price'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _LevelController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          label: const Text('Level'),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            label: const Text('Rank'),
                                            filled: true,
                                            fillColor: const Color(0xFFFFFFFF),
                                            border: const OutlineInputBorder()),
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
                                      border: const OutlineInputBorder()),
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
                                      'Add',
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
                                setState(() {
                                  
                                });
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
              Container(
                // Update page ------------------------------------------------------------------------------------------------------------------------------
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight * 1,
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          color: Color(0xff777777),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: FutureBuilder(
                          future: banbooList,
                          builder: (context, snapshot) {
                            var data = snapshot.data;

                            if (data != null) {
                              return ListView.builder(
                                itemCount:
                                    data.length, // Jumlah item dalam data
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return GestureDetector(
                                    onTap: () => detailPressed(
                                      item.BanbooID,
                                      item.BanbooName,
                                      item.BanbooHP,
                                      item.BanbooATK,
                                      item.BanbooDEF,
                                      item.BanbooImpact,
                                      item.BanbooCRate,
                                      item.BanbooCDmg,
                                      item.BanbooPRatio,
                                      item.BanbooAMastery,
                                      item.BanbooRank,
                                      base64Decode(item.BanbooImage),
                                      item.BanbooDescription,
                                      item.BanbooPrice,
                                      item.BanbooLevel,
                                    ),
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
                                        height: 77,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF999999),
                                          border: Border.all(
                                            color: const Color(0xFF333333),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                          subtitle: RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "BanbooID = ",
                                                  style: TextStyle(
                                                    fontFamily: "Poppin",
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      item.BanbooID.toString(),
                                                  style: const TextStyle(
                                                    fontFamily: "Poppin",
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
                    ],
                  ),
                ),
              ),
              Container(
                // Delete page ------------------------------------------------------------------------------------------------------------------------------
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight * 1,
                        padding: const EdgeInsets.all(
                            30), // Padding inside the container
                        decoration: const BoxDecoration(
                          color: Color(0xff777777),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: FutureBuilder(
                          future: banbooList,
                          builder: (context, snapshot) {
                            var data = snapshot.data;

                            if (data != null) {
                              return ListView.builder(
                                itemCount:
                                    data.length, // Jumlah item dalam data
                                itemBuilder: (context, index) {
                                  final item = data[index];

                                  return Card(
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
                                      height: 77,
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
                                          subtitle: RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "BanbooID = ",
                                                  style: TextStyle(
                                                    fontFamily: "Poppin",
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      item.BanbooID.toString(),
                                                  style: const TextStyle(
                                                    fontFamily: "Poppin",
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: Color(0xFF333333),
                                            ),
                                            onPressed: () =>
                                                _deleteOnPressed(item.BanbooID),
                                          )),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
