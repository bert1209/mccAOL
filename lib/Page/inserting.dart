import 'package:flutter/material.dart';

class InsertProduct extends StatefulWidget { // halaman insert product
  const InsertProduct({super.key});

  @override
  State<InsertProduct> createState() => _InsertProduct();
}

class _InsertProduct extends State<InsertProduct>{

  final TextEditingController _banbooController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeIdController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  // level: 1 - 70;
  @override
  // sign / home / catalog / deskripsi / admin / user
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; //buat screen height tapi pake persentase dari screen
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xFF777777),
            bottom:
            TabBar(
                tabs: [
                  Tab(child: Text('Insert', style: TextStyle(fontFamily: 'SemiPoppins', color: Colors.white),),),
                  Tab(child: Text('Update', style: TextStyle(fontFamily: 'SemiPoppins', color: Colors.white),),),
                  Tab(child: Text('Delete', style: TextStyle(fontFamily: 'SemiPoppins', color: Colors.white),),)
                ]
            ),
            leading:
            Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: IconButton(
                  color: Color(0xFF333333),
                  onPressed: (){},
                  icon: const Icon(Icons.arrow_back_rounded)
              ),
            ),
            title:
            Container(
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
              Container( // Insert page ------------------------------------------------------------------------------------------------------------------------------
                child: SingleChildScrollView(
                  child:
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.33,
                        //color: Colors.green,
                        child: Center(
                          child: Transform.scale(
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
                            padding: const EdgeInsets.all(30), // Padding inside the container
                            decoration: const BoxDecoration( // warna border
                              color: Colors.white,
                              // boxShadow: [ // box shadow
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     blurStyle: BlurStyle.normal,
                              //     color: Colors.grey[400]!,
                              //     offset: Offset.zero,
                              //     spreadRadius: 2.5,
                              //   )
                              // ],
                              borderRadius: BorderRadius.only( // lengkungan border
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)
                              ),
                            ),

                            child: Column(
                              children: [
                                const SizedBox(height: 25),

                                Row(
                                  children: [
                                    Image.asset('lib/Assets/banbooIcon.png'),
                                    const SizedBox(width: 15),
                                    Expanded(child:
                                    TextField(
                                      controller: _banbooController,
                                      decoration: const InputDecoration(
                                          label: Text('Name*'),
                                          filled: true,
                                          fillColor: Color(0xFFEFEFEF),
                                          border: OutlineInputBorder()
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                Row(
                                  children: [
                                    const Icon(Icons.tag_rounded),
                                    const SizedBox(width: 15),
                                    Expanded(child:
                                    TextField(
                                      controller: _typeIdController,
                                      decoration: const InputDecoration(
                                          label: Text('Type Id*'),
                                          filled: true,
                                          fillColor: Color(0xFFEFEFEF),
                                          border: OutlineInputBorder()
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                Row(
                                  children: [
                                    const Icon(Icons.format_list_numbered_rounded),
                                    const SizedBox(width: 15),
                                    Expanded(child:
                                    TextField(
                                      controller: _levelController,
                                      decoration: const InputDecoration(
                                          label: Text('Level*'),
                                          filled: true,
                                          fillColor: Color(0xFFEFEFEF),
                                          border: OutlineInputBorder()
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                Row(
                                  children: [
                                    Image.asset('lib/Assets/yen.png'),
                                    const SizedBox(width: 15),
                                    Expanded(child:
                                    TextField(
                                      controller: _priceController,
                                      decoration: const InputDecoration(
                                          label: Text('Price*'),
                                          filled: true,
                                          fillColor: Color(0xFFEFEFEF),
                                          border: OutlineInputBorder()
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
                                  decoration: const InputDecoration(
                                      label: Text('Description'),
                                      filled: true,
                                      fillColor: Color(0xFFEFEFEF),
                                      border: OutlineInputBorder()
                                  ),
                                ),
                                const SizedBox(height: 50),

                                Center( // Tombol Add Product
                                  child: ElevatedButton(
                                    onPressed: (){},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF333333), // Change the background color
                                      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 10), // Add padding if needed
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
                        right: screenWidth * 0.1, // Adjust this to control spacing from the right edge
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
                              onPressed: () {},
                              icon: const Icon(Icons.edit_rounded, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container( // Update page ------------------------------------------------------------------------------------------------------------------------------
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Container(
                        height: screenHeight * 1,
                        padding: const EdgeInsets.all(30), // Padding inside the container
                        decoration: const BoxDecoration( // warna border
                          color: Colors.white,
                          // boxShadow: [ // box shadow
                          //   BoxShadow(
                          //     blurRadius: 3,
                          //     blurStyle: BlurStyle.normal,
                          //     color: Colors.grey[400]!,
                          //     offset: Offset.zero,
                          //     spreadRadius: 2.5,
                          //   )
                          // ],
                          borderRadius: BorderRadius.only( // lengkungan border
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container( // Delete page ------------------------------------------------------------------------------------------------------------------------------
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Container(
                        height: screenHeight * 1,
                        padding: const EdgeInsets.all(30), // Padding inside the container
                        decoration: const BoxDecoration( // warna border
                          color: Colors.white,
                          // boxShadow: [ // box shadow
                          //   BoxShadow(
                          //     blurRadius: 3,
                          //     blurStyle: BlurStyle.normal,
                          //     color: Colors.grey[400]!,
                          //     offset: Offset.zero,
                          //     spreadRadius: 2.5,
                          //   )
                          // ],
                          borderRadius: BorderRadius.only( // lengkungan border
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                          ),
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