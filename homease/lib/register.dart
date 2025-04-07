import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- ADD THIS
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/location_perm.dart';
import 'package:homease/login.dart';
 

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 44),
              Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: const Color.fromRGBO(100, 27, 180, 1),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 50,
                child: Text(
                  "Create an account so you can explore all the available services",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              buildTextField(context, hintText: "UserName"),
              const SizedBox(height: 20),
              buildTextField(context, hintText: "Email"),
              const SizedBox(height: 20),
              buildTextField(context, hintText: "Password", obscureText: true),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: MediaQuery.sizeOf(context).width - 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign up
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: const Color.fromRGBO(100, 27, 180, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationPerm(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: Text(
                  "Already have an account",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color.fromRGBO(73, 73, 73, 1),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Or continue with",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color.fromRGBO(103, 89, 255, 1),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialIcon("assets/onboarding/Frame 1.svg"),
                  const SizedBox(width: 15),
                  socialIcon("assets/onboarding/Frame 1 (1).svg"),
                  const SizedBox(width: 15),
                  socialIcon("assets/onboarding/ic_baseline-apple.svg"),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable input field
  Widget buildTextField(BuildContext context,
      {required String hintText, bool obscureText = false}) {
    return SizedBox(
      height: 55,
      width: MediaQuery.sizeOf(context).width - 50,
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(241, 244, 255, 1),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 2,
              color: Color.fromRGBO(103, 89, 255, 1),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Social Icon Widget
  Widget socialIcon(String assetPath) {
    return GestureDetector(
      onTap: () {
        debugPrint('Tapped: $assetPath');
      },
      child: Container(
        width: 60,
        height: 44,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(236, 236, 236, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(assetPath),
      ),
    );
  }
}
