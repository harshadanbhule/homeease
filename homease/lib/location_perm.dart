import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationPerm extends StatefulWidget {
  const LocationPerm({super.key});

  @override
  State<LocationPerm> createState() => _LocationPerm();
}

class _LocationPerm extends State<LocationPerm> {
  bool animate = false;
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        animate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedSlide(
                offset: animate ? Offset.zero : const Offset(-1.5, -1),
                duration: const Duration(milliseconds: 800),
                child: Image.asset("assets/splash/image 2 (1).png"),
              ),
              AnimatedSlide(
                offset: animate ? Offset.zero : const Offset(1.5, -1),
                duration: const Duration(milliseconds: 800),
                child: Image.asset("assets/splash/IMG_0157 1.png"),
              ),
            ],
          ),
          SvgPicture.asset('assets/onboarding/Address-amico 1.svg',height: 200,),
          Text("Allow location access?",style: GoogleFonts.bricolageGrotesque(fontSize: 30,fontWeight: FontWeight.w700,color: Color.fromRGBO(27, 36, 49, 1)),),
          Container(
             
            height: 50,
            width: MediaQuery.sizeOf(context).width-75,
            child: Text(textAlign: TextAlign.center,"We need your location access to easily find Skillr professionals around you.",style: GoogleFonts.bricolageGrotesque(fontSize: 15,fontWeight: FontWeight.normal,color: Color.fromRGBO(119, 119, 119, 1)),)),
          Container(
            height: 50,
            width: MediaQuery.sizeOf(context).width-50,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(50),
              color: Color.fromRGBO(35, 51, 74, 1)
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(textAlign: TextAlign.center,"Allow location access",style: GoogleFonts.bricolageGrotesque(fontSize: 17,fontWeight: FontWeight.w800,color: Colors.white)),
            ),
          ),
          Text("Skip this step",style: GoogleFonts.bricolageGrotesque( fontSize: 15,fontWeight: FontWeight.w500,color: Color.fromRGBO(49,49,49,1)),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedSlide(
                offset: animate ? Offset.zero : const Offset(-1.5, 1),
                duration: const Duration(milliseconds: 800),
                child: Image.asset("assets/splash/image 3.png"),
              ),
              AnimatedSlide(
                offset: animate ? Offset.zero : const Offset(1.5, 1),
                duration: const Duration(milliseconds: 800),
                child: Image.asset("assets/onboarding/image 4.png"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
