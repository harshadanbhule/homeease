import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
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
    Future.delayed(const Duration(milliseconds: 100), () {
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
          Image.asset("assets/splash/image.png", height: 200),

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
                child: Image.asset("assets/splash/image 4.png"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
