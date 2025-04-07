import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class page_3 extends StatelessWidget {
  const page_3({super.key});

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
                            image: AssetImage("assets/onboarding/Group 34489 (3).png"),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.asset(
                            "assets/onboarding/new_image_3.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 180),
                          child: Image(
                            image: AssetImage(
                              'assets/onboarding/Group 34487 (2).png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(
                    height: 115,
                    width: 300,
                    child: Text("Professional home cleaning",
                    textAlign: TextAlign.center ,
                    style: GoogleFonts.interTight(fontWeight: FontWeight.bold,fontSize: 32),),
                  ),
                   SizedBox(height: 10),
                  // SizedBox(
                  //   width: MediaQuery.sizeOf(context).width-30,
                  //   child: Text(textAlign: TextAlign.center,"Experience a spotless home with professional cleaning services at your doorstep.",style: GoogleFonts.interTight(fontSize: 15,fontWeight: FontWeight.w400),),
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
