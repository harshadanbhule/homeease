import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:card_loading/card_loading.dart';
import 'package:homease/categories.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:homease/onboarding_screen.dart';
import 'package:homease/splash_2.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const Homepage());
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomLoading(),
    );
  }
}

class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key});
  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> {
  bool isLoading = true;
  int _selectedIndex = 0;

  // final List<Widget> _screens = [
  //   Center(child: Text('Home')),
  //   Center(child: Text('Likes')),
  //   Center(child: Text('Search')),
  //   Center(child: Text('Profile')),
  // ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Icon(CupertinoIcons.map_fill, color: Colors.black),
            const SizedBox(width: 10),
            SizedBox(
              width: 121,
              height: 35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CURRENT LOCATION ",
                    style: GoogleFonts.interTight(
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      color: const Color.fromRGBO(99, 106, 117, 1),
                    ),
                  ),
                  Text(
                    "41,Vadgoan Bk.",
                    style: GoogleFonts.interTight(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: const Color.fromRGBO(23, 43, 77, 1),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                const SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: const Color(0xFF8C6239),
                  highlightColor: const Color(0xFFF4BF4B),
                  child: Text(
                    "BRONZE",
                    style: GoogleFonts.interTight(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8C6239),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Text(
                  "0 POINTS",
                  style: GoogleFonts.interTight(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(99, 106, 117, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            Shimmer.fromColors(
              baseColor: const Color(0xFF8C6239),
              highlightColor: const Color(0xFFF4BF4B),
              child: SvgPicture.asset(
                "assets/homescreen/Badge.svg",
                height: 24,
                width: 24,
              ),
            ),

            const SizedBox(width: 10),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            //
            // SECTION 1: Greeting + Search
            //
            isLoading
                ? Column(
                  children: [
                    CardLoading(
                      height: 20,
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      borderRadius: BorderRadius.circular(10),
                      animationDuration: const Duration(milliseconds: 1200),
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    CardLoading(
                      height: 20,
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      borderRadius: BorderRadius.circular(10),
                      animationDuration: const Duration(milliseconds: 1200),
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    CardLoading(
                      height: 60,
                      width: MediaQuery.sizeOf(context).width - 40,
                      borderRadius: BorderRadius.circular(15),
                      animationDuration: const Duration(milliseconds: 1200),
                      margin: const EdgeInsets.only(bottom: 20),
                    ),
                  ],
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HELLO harshad 👋",
                          style: GoogleFonts.inter(
                            letterSpacing: 1.5,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(102, 108, 137, 1),
                          ),
                        ),
                        Text(
                          "What you are looking for today",
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: const Color.fromRGBO(23, 43, 77, 1),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width - 50,
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TextField(
                              decoration: InputDecoration(
                                suffixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/homescreen/Group 34308.svg",
                                    ),
                                  ],
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: const Color.fromRGBO(
                                  248,
                                  248,
                                  248,
                                  1,
                                ),
                                filled: true,
                                hintText: "Search what you need...",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            const SizedBox(height: 20),

            //
            // SECTION 2: Offer Scroll View
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 220,
                width: MediaQuery.sizeOf(context).width - 30,
                child:
                    isLoading
                        ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.all(20),
                                child: CardLoading(
                                  height: 160,
                                  width: 289,
                                  borderRadius: BorderRadius.circular(14),
                                  animationDuration: const Duration(
                                    milliseconds: 1200,
                                  ),
                                  cardLoadingTheme: CardLoadingTheme(
                                    colorOne: Colors.grey[300]!,
                                    colorTwo: Colors.grey[100]!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              offerCard(
                                bgColor: const Color.fromRGBO(224, 255, 236, 1),
                                title: "Offer AC service",
                                discount: "Get 25%",
                                buttonColor: const Color.fromARGB(
                                  255,
                                  67,
                                  208,
                                  126,
                                ),
                              ),
                              offerCard(
                                bgColor: const Color.fromARGB(
                                  255,
                                  224,
                                  226,
                                  255,
                                ),
                                title: "Offer",
                                discount: "Get 15%",
                                buttonColor: const Color.fromARGB(
                                  255,
                                  67,
                                  91,
                                  208,
                                ),
                              ),
                              offerCard(
                                bgColor: const Color.fromARGB(
                                  255,
                                  255,
                                  242,
                                  224,
                                ),
                                title: "Offer",
                                discount: "Get 15%",
                                buttonColor: const Color.fromARGB(
                                  255,
                                  234,
                                  184,
                                  91,
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ),

            ///
            ///
            ///
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 120,
                width: MediaQuery.sizeOf(context).width - 30,
                child:
                    isLoading
                        ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: 20,
                            right: 5,
                            bottom: 5,
                          ),
                          child: Row(
                            children: List.generate(4, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Column(
                                  children: [
                                    CardLoading(
                                      height: 58,
                                      width: 58,
                                      borderRadius: BorderRadius.circular(100),
                                      animationDuration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                      cardLoadingTheme: CardLoadingTheme(
                                        colorOne: Colors.grey.shade300,
                                        colorTwo: Colors.grey.shade100,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CardLoading(
                                      height: 10,
                                      width: 50,
                                      borderRadius: BorderRadius.circular(6),
                                      animationDuration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                      cardLoadingTheme: CardLoadingTheme(
                                        colorOne: Colors.grey.shade300,
                                        colorTwo: Colors.grey.shade100,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: 20,
                            right: 5,
                            bottom: 5,
                          ),
                          child: Row(
                            children: [
                              // 🟢 Category 1
                              SizedBox(
                                height: 88,
                                width: 61,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 58,
                                      width: 58,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(255, 188, 153, 1),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/homescreen/Group 34256.svg",
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "AC Repair",
                                      style: GoogleFonts.interTight(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: const Color.fromRGBO(
                                          65,
                                          64,
                                          93,
                                          1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 30),

                              // 🟣 Category 2
                              SizedBox(
                                height: 88,
                                width: 61,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 58,
                                      width: 58,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(202, 189, 255, 1),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/homescreen/Group 34257.svg",
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Beauty",
                                      style: GoogleFonts.interTight(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: const Color.fromRGBO(
                                          65,
                                          64,
                                          93,
                                          1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 30),

                              // 🔵 Category 3
                              SizedBox(
                                height: 88,
                                width: 61,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 58,
                                      width: 58,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(177, 229, 252, 1),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/homescreen/Group 34258.svg",
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Appliance",
                                      style: GoogleFonts.interTight(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: const Color.fromRGBO(
                                          65,
                                          64,
                                          93,
                                          1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 30),

                              // ➡️ See All
                              SizedBox(
                                height: 88,
                                width: 61,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return Categories();
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 58,
                                        width: 58,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromRGBO(
                                            223,
                                            245,
                                            255,
                                            1,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "See All",
                                      style: GoogleFonts.interTight(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: const Color.fromRGBO(
                                          65,
                                          64,
                                          93,
                                          1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 275,
                width: MediaQuery.sizeOf(context).width - 30,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30,
                            width: 6,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(202, 189, 255, 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 10),
                          isLoading
                              ? CardLoading(
                                height: 20,
                                width: 160,
                                borderRadius: BorderRadius.circular(8),
                              )
                              : Text(
                                "Cleaning Services",
                                style: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                          SizedBox(width: 80),
                          Container(
                            height: 35,
                            width: 83,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color.fromRGBO(239, 239, 239, 1),
                              border: Border.all(width: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  isLoading
                                      ? CardLoading(
                                        height: 12,
                                        width: 40,
                                        borderRadius: BorderRadius.circular(8),
                                      )
                                      : Text(
                                        "See All",
                                        style: GoogleFonts.interTight(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 13,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 190,
                              width: 140,
                              child: Column(
                                children: [
                                  isLoading
                                      ? CardLoading(
                                        height: 140,
                                        width: 154,
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                      : SizedBox(
                                        height: 140,
                                        width: 154,
                                        child: Image.asset(
                                          "assets/homescreen/Mask Group.png",
                                        ),
                                      ),
                                  SizedBox(height: 8),
                                  isLoading
                                      ? CardLoading(
                                        height: 15,
                                        width: 100,
                                        borderRadius: BorderRadius.circular(8),
                                      )
                                      : Text(
                                        "Home Cleaning",
                                        style: GoogleFonts.interTight(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: 190,
                              width: 140,
                              child: Column(
                                children: [
                                  isLoading
                                      ? CardLoading(
                                        height: 140,
                                        width: 154,
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                      : SizedBox(
                                        height: 140,
                                        width: 154,
                                        child: Image.asset(
                                          "assets/homescreen/Mask Group (1).png",
                                        ),
                                      ),
                                  SizedBox(height: 8),
                                  isLoading
                                      ? CardLoading(
                                        height: 15,
                                        width: 100,
                                        borderRadius: BorderRadius.circular(8),
                                      )
                                      : Text(
                                        "Carpet Cleaning",
                                        style: GoogleFonts.interTight(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: 190,
                              width: 140,
                              child: Column(
                                children: [
                                  isLoading
                                      ? CardLoading(
                                        height: 140,
                                        width: 154,
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                      : SizedBox(
                                        height: 140,
                                        width: 154,
                                        child: Image.asset(
                                          "assets/homescreen/Mask Group (2).png",
                                        ),
                                      ),
                                  SizedBox(height: 8),
                                  isLoading
                                      ? CardLoading(
                                        height: 15,
                                        width: 100,
                                        borderRadius: BorderRadius.circular(8),
                                      )
                                      : Text(
                                        "AC Cleaning",
                                        style: GoogleFonts.interTight(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            ///
            ///
            ///
            ///
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GNav(
              activeColor: Colors.white,
              backgroundColor: Colors.transparent,
              haptic: true,
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(color: Colors.black, width: 0.1),
              curve: Curves.easeOutExpo,
              duration: Duration(milliseconds: 300),
              gap: 8,
              iconSize: MediaQuery.of(context).size.width < 400 ? 22 : 26,
              tabBackgroundColor: Color.fromRGBO(100, 27, 180, 1),
              padding:
                  MediaQuery.of(context).size.width < 400
                      ? EdgeInsets.symmetric(horizontal: 15, vertical: 8)
                      : EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });

                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Splash_2()),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Splash_2()),
                    );
                    break;
                  // more cases...
                }
              },
              tabs: [
                GButton(
                  icon: Icons.circle,
                  iconColor: Colors.transparent,
                  leading: Shimmer.fromColors(
                    baseColor:
                        _selectedIndex == 0 ? Colors.white : Colors.black,
                    highlightColor: Colors.grey.shade300,
                    child: Icon(LineIcons.home, size: 26),
                  ),
                  text: 'Home',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                GButton(
                  icon: Icons.circle,
                  iconColor: Colors.transparent,
                  leading: Shimmer.fromColors(
                    baseColor:
                        _selectedIndex == 1 ? Colors.white : Colors.black,
                    highlightColor: Colors.grey.shade300,
                    child: Icon(LineIcons.book, size: 26),
                  ),
                  text: 'Bookings',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                GButton(
                  icon: Icons.circle,
                  iconColor: Colors.transparent,
                  leading: Shimmer.fromColors(
                    baseColor:
                        _selectedIndex == 2 ? Colors.white : Colors.black,
                    highlightColor: Colors.grey.shade300,
                    child: SvgPicture.asset(
                      "assets/homescreen/1538298822.svg",
                      height: 37,
                      width: 37,
                      color: _selectedIndex == 2 ? Colors.white : Colors.black,
                    ),
                  ),
                  text: 'ChatBot',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                GButton(
                  icon: Icons.circle,
                  iconColor: Colors.transparent,
                  leading: Shimmer.fromColors(
                    baseColor:
                        _selectedIndex == 3 ? Colors.white : Colors.black,
                    highlightColor: Colors.grey.shade300,
                    child: Icon(LineIcons.user, size: 26),
                  ),
                  text: 'Profile',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget offerCard({
    required Color bgColor,
    required String title,
    required String discount,
    required Color buttonColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10),
      child: Container(
        height: 160,
        width: 289,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            right: 10,
            left: 10,
            bottom: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.info_rounded, size: 20),
                ],
              ),
              Text(
                discount,
                style: GoogleFonts.interTight(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                height: 30,
                width: 106,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Text(
                      "Grab Offer",
                      style: GoogleFonts.interTight(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: buttonColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 14,
                      color: buttonColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
