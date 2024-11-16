import 'dart:async';
import 'package:flutter/cupertino.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  List<String> images = [
    "lib/Assets/BangboosFanart0.png",
    "lib/Assets/BangboosFanart1.png",
  ];

  int currIdx = 0;
  PageController pageController = PageController(initialPage: 0);
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
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
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      child: PageView.builder(
        itemCount: images.length,
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            currIdx = value;
          });
        },
        itemBuilder: (context, index) {
          return Image.asset(images[index]);
        },
      ),
    );
  }
}
