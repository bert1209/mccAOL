import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  List<String> images = [
    "lib/Assets/BangboosFanart0.png",
    "lib/Assets/BangboosFanart1.png",
    "lib/Assets/BangboosFanart2.png",
    //"lib/Assets/TierList.png"
  ];

  int currIdx = 0;
  PageController pageController = PageController(initialPage: 0);
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      currIdx = (currIdx + 1) % images.length;
      moveCarousel(currIdx);
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void moveCarousel(int idx) {
    pageController.animateToPage(
      idx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return
      Container(
        width: screenWidth * 0.9,
        height: 200,
        decoration: const BoxDecoration(
          color: Color(0xFF777777),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
          child: PageView.builder(
            itemCount: images.length,
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                currIdx = value;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                images[index],
                fit: BoxFit.cover, // Ensures the image covers the mask properly
              );
            },
          ),
        ),
      );
  }
}
