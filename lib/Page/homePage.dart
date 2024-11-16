import 'package:aol_mcc/Function/ImageButton.dart';
import 'package:flutter/material.dart';
import 'package:aol_mcc/Function/imageCarousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF777777),
      appBar: AppBar(
        toolbarHeight: 100,
        leading:
            IconButton(
              splashColor: Color(0xFF111111),
              onPressed: () {

              },
              icon: Icon(Icons.account_circle_rounded),
              color: Color(0xFF333333),
              iconSize: 60,
              padding: EdgeInsets.all(25),
            ),
        title: Text("Banboo\n  Store",
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
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageButton(
                      images: "lib/Assets/Inventory.png",
                      onTap: () {

                      },
                      height: 70,
                      widht: 70,
                      padding: 10
                  ),
                  imageButton(
                      images: "lib/Assets/catalogue.png",
                      onTap: () {

                      },
                      height: 70,
                      widht: 70,
                      padding: 10
                  ),
                  imageButton(
                      images: "lib/Assets/wallet.png",
                      onTap: () {

                      },
                      height: 70,
                      widht: 70,
                      padding: 10
                  ),
                  imageButton(
                      images: "lib/Assets/cart.png",
                      onTap: () {

                      },
                      height: 70,
                      widht: 70,
                      padding: 10
                  ),
                ],
              ),
              
              SizedBox(height: 15,),
              
              Row(
                children: [
                   Padding(
                      padding: EdgeInsets.only(
                          left: 20
                      ),
                  ),
                  Text("Popular Art",
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: "Poppin",
                    fontWeight: FontWeight.bold,
                  ),
                  )
                ],
              ),


              ImageCarousel(),

              SizedBox(height: 30,),

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20
                    ),
                  ),
                  Text("Recently Seen",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: "Poppin",
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}


