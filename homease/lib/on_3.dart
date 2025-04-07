import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Page_3 extends StatelessWidget {
  const Page_3({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Page3(),
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
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
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                  ),
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
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                  ),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                     child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                           Padding(
                            padding: EdgeInsets.only(top: 150),
                            child: SvgPicture.asset("assets/svg_images/Group 34612.svg")
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.asset(
                              "assets/onboarding/new_image_3.png",
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high
                            ),
                          ),
                           Padding(
                            padding: EdgeInsets.only(top: 180),
                            child:  SvgPicture.asset("assets/svg_images/Group 34613.svg"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 115,
                    width: 300,
                    child: Text(
                      "Professional home cleaning",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 30,
                    child: Text(
                      "Experience a spotless home with professional cleaning services at your doorstep.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
