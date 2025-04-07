import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemChrome
import 'package:google_fonts/google_fonts.dart';

class page_1 extends StatelessWidget {
  const page_1({super.key});

  @override
  Widget build(BuildContext context) {
    // Don't use MaterialApp here, it's already wrapped in the main app
    return const Page1();
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  void initState() {
    super.initState();

    // Enable immersive fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Top-left decoration
            Positioned(
              top: 1,
              left: 1,
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 202, 202, 1),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
                ),
              ),
            ),
            // Top-right decoration
            Positioned(
              top: 1,
              right: 1,
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 202, 202, 1),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
                ),
              ),
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Adjust vertical space
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height - 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: Image(
                            image: AssetImage("assets/onboarding/Group 34489 (1).png"),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.asset(
                            "assets/onboarding/new_image.png",
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 180),
                          child: Image(
                            image: AssetImage(
                              'assets/onboarding/Group 34487.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 115,
                    width: 300,
                    child: Text(
                      "Beauty parlour at your home",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Optional Description Text
                  // SizedBox(
                  //   width: MediaQuery.sizeOf(context).width - 30,
                  //   child: Text(
                  //     "Experience salon-quality beauty treatments in the comfort of your own home.",
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.interTight(fontSize: 15, fontWeight: FontWeight.w400),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
