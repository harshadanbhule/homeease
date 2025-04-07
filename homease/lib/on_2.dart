import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class page_2 extends StatelessWidget {
  const page_2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Page2(),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Container at the top-left corner
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
            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height-250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: Image(
                            image: AssetImage("assets/onboarding/Group 34489 (2).png"),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.asset(
                            "assets/onboarding/new_image_2.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 180),
                          child: Image(
                            image: AssetImage(
                              'assets/onboarding/Group 34487 (1).png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Container(
                    alignment: Alignment(0,0.1),
                    height: 115,
                    width: 300,
                    child: Text("Plumber & expert nearby you",
                    textAlign: TextAlign.center ,
                    style: GoogleFonts.interTight(fontWeight: FontWeight.bold,fontSize: 32),),
                  ),
                  SizedBox(height: 10),
                  // SizedBox(
                  //   width: MediaQuery.sizeOf(context).width-30,
                  //   child: Text(textAlign: TextAlign.center,"Find trusted plumbers and experts near you for quick and reliable service.",style: GoogleFonts.interTight(fontSize: 15,fontWeight: FontWeight.w400),),
                  // ),
                  
                  SizedBox(height: 100),                
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
