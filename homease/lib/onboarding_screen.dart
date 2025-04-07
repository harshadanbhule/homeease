import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- ADD THIS
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/on_1.dart';
import 'package:homease/on_2.dart';
import 'package:homease/on_3.dart';
import 'package:homease/splash_2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void initState() {
    super.initState();

    // Enable immersive sticky fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              page_1(),
              Page_2(),
              Page_3(),
            ],
          ),

          // Page Indicator
          Container(
            alignment: const Alignment(0, 0.70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const SlideEffect(
                    dotColor: Color.fromRGBO(183, 177, 255, 1),
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: Color.fromRGBO(103, 89, 255, 1),
                  ),
                ),
              ],
            ),
          ),

          // Next / Done Button
          Container(
            alignment: const Alignment(0, 0.95),
            child: GestureDetector(
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromRGBO(100, 27, 180, 1),
                ),
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
              onTap: () {
                if (onLastPage) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Splash_2()),
                  );
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),

          // Skip Button
          Container(
            alignment: const Alignment(0.95, -0.90),
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(181, 235, 205, 1)),
              ),
              onPressed: () {
                _controller.jumpToPage(2);
              },
              child: Text(
                "Skip",
                style: GoogleFonts.interTight(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
