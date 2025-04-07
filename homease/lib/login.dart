import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  screenHeight -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Text(
                    "Login here",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: const Color.fromRGBO(100, 27, 180, 1),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Welcome back you’ve \nbeen missed!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email input
                  // Email Field
                  SizedBox(
                    height: 55,
                    width: MediaQuery.sizeOf(context).width - 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(241, 244, 255, 1),
                        hintText: "Email",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 17,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromRGBO(103, 89, 255, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  SizedBox(
                    height: 55,
                    width: MediaQuery.sizeOf(context).width - 50,
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(241, 244, 255, 1),
                        hintText: "Password",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 17,
                        ),
                        suffixIcon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromRGBO(103, 89, 255, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot Password Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Checkbox(value: false, onChanged: (val) {}),
                        const Spacer(),
                        Text(
                          "Forgot your password?",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: const Color.fromRGBO(100, 27, 180, 1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sign In Button
                  SizedBox(
                    height: 60,
                    width: MediaQuery.sizeOf(context).width - 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: const Color.fromRGBO(100, 27, 180, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Navigate to Register
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: Text(
                      "Create new account",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: const Color.fromRGBO(73, 73, 73, 1),
                      ),
                    ),
                  ),

                  const SizedBox(height: 70),

                  Text(
                    "Or continue with",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color.fromRGBO(103, 89, 255, 1),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Social icons
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
        ),
      ),
    );
  }

  Widget socialIcon(String path) {
    return Container(
      width: 60,
      height: 44,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(236, 236, 236, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: SvgPicture.asset(path),
    );
  }
}
