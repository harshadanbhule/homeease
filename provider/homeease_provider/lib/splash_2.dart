import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeease_provider/login.dart';
import 'package:homeease_provider/register.dart';

class Splash_2 extends StatefulWidget {
  const Splash_2({super.key});

  @override
  State<Splash_2> createState() => _SplashState();
}

class _SplashState extends State<Splash_2> {
  bool animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        animate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(100, 27, 180, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top images
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

            // Middle content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width-80,
                    child: Text(
                      "Finding and connecting with trusted local professionals around you.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.darkerGrotesque(
                        color: Color.fromRGBO(224, 209, 240, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sign up button
                  GestureDetector(onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },

                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.sizeOf(context).width - 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Text(
                        "Sign up to HomeEase",
                        style: GoogleFonts.inter(
                          color: Color.fromRGBO(100, 27, 180, 1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Login button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.sizeOf(context).width - 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromRGBO(100, 27, 180, 1),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom images
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
      ),
    );
  }
}
