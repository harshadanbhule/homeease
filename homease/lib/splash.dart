import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/onboarding_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool animate = false;

  @override
  void initState() {
    super.initState();

    // Make the app fullscreen (hide status and nav bars)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Trigger animations after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        animate = true;
      });
    });
  }

   

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splashIconSize: MediaQuery.of(context).size.height,
      backgroundColor: const Color.fromRGBO(100, 27, 180, 1),
      nextScreen: const OnBoardingScreen(),
      splashTransition: SplashTransition.fadeTransition,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top row
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
          

          // Center logo/image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/splash/home_logo.svg"),
              Text("HOMEEASE",style: GoogleFonts.robotoCondensed(fontSize: 48,fontWeight: FontWeight.w700,color: Colors.white),)
          ],),
           SizedBox(
    height: 30,
  ),
 
          // Bottom row
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
          ),
        ],
      ),
    );
  }
}
