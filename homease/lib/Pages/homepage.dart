import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:card_loading/card_loading.dart';
import 'package:homease/Custom/custom_appbar.dart';
import 'package:homease/Custom/custom_nav_bar.dart';
import 'package:homease/Pages/Profile.dart';
import 'package:homease/Pages/booking.dart';
import 'package:homease/Pages/chatbot.dart';
import 'package:homease/Pages/service/service_page.dart';
import 'package:homease/Pages/service/sub_service_detail_page.dart';
import 'package:homease/Pages/service/sub_service_page.dart';
import 'package:homease/categories.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:homease/controllers/location_controller.dart';
import 'package:homease/controllers/user_controller.dart';
import 'package:homease/model/sub_service_model.dart';
import 'package:homease/onboarding_screen.dart';
import 'package:homease/service%20data/service_data.dart';
import 'package:homease/splash_2.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key});
  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> {
  bool isLoading = true;
  int _selectedIndex = 0;
  final locationController = Get.find<LocationController>();
  Future<void> _checkFirstTimeLoading() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyLoaded = prefs.getBool('alreadyLoaded') ?? false;

    if (!alreadyLoaded) {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        isLoading = false;
      });
      prefs.setBool('alreadyLoaded', true);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // final List<Widget> _screens = [
  //   Center(child: Text('Home')),
  //   Center(child: Text('Likes')),
  //   Center(child: Text('Search')),
  //   Center(child: Text('Profile')),
  // ];

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
    _checkFirstTimeLoading();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchUserLocation() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc =
          await FirebaseFirestore.instance
              .collection('user_locations')
              .doc(user.uid)
              .get();

      final data = doc.data();
      if (data != null) {
        print("Fetched Data: $data");

        final lat = data['coordinates']['latitude'];
        final lng = data['coordinates']['longitude'];
        final placemarks = await placemarkFromCoordinates(lat, lng);
        final place = placemarks.first;
        locationController.updateLocation("${place.street}, ${place.locality}");

        final firstName = data['firstName'] ?? '';
        final lastName = data['lastName'] ?? '';
        final fullName = "$firstName $lastName";
        print("Full name: $fullName");
        locationController.updateFullName(fullName);
      } else {
        print("Document doesn't exist.");
      }
    } catch (e) {
      print("Error: $e");
      locationController.updateLocation("Error fetching location");
      locationController.updateFullName("Error fetching name");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

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
                        Obx(
                          () => Text(
                            "HELLO ${locationController.fullName.value.toUpperCase()} 👋",

                            style: GoogleFonts.inter(
                              letterSpacing: 1.5,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(102, 108, 137, 1),
                            ),
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
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                height:
                    MediaQuery.of(context).size.height *
                    0.19, // ⬅️ Reduced height responsively
                width: MediaQuery.of(context).size.width - 30,
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
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.16, // ⬅️ Responsive loader
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
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
                                bgColor: const Color(0xFF8C6239),
                                title: "Offer AC service",
                                discount: "Get 25%",
                                buttonColor: const Color.fromARGB(255, 0, 255, 106),
                                highColor : const Color(0xFFF4BF4B),
                                couponCode: "Homeoff25"
                              ),
                              offerCard(
                                bgColor: const Color.fromRGBO(169, 169, 169, 1),
                                title: "Offer",
                                discount: "Get 15%",
                                buttonColor: const Color.fromARGB(255, 0, 42, 255),
                                highColor: const Color.fromRGBO(220, 220, 220, 1),
                                couponCode: "Homeoff15"
                              ),
                              offerCard(
                                bgColor: const Color(0xFFCD7F32),
                                title: "Offer",
                                discount: "Get 10%",
                                buttonColor: const Color.fromARGB(255, 255, 166, 0),
                                highColor: const Color(0xFFE6B980),
                                couponCode: "Homeoff10"
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: MediaQuery.of(context).size.height * 0.16,
                width: double.infinity,
                child:
                    isLoading
                        ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CardLoading(
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.17,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.17,
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
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 🔧 AC Repair
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final acService = services.firstWhere(
                                        (s) => s.name == 'AC Service',
                                      );
                                      await Get.to(
                                        () =>
                                            SubServicePage(service: acService),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.17,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.17,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(255, 188, 153, 1),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/homescreen/Group 34256.svg",
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "AC Repair",
                                    style: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Color.fromRGBO(65, 64, 93, 1),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            // 💅 Beauty
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final acService = services.firstWhere(
                                        (s) => s.name == 'Beauty',
                                      );
                                      await Get.to(
                                        () =>
                                            SubServicePage(service: acService),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.17,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.17,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(202, 189, 255, 1),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/homescreen/Group 34257.svg",
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Beauty",
                                    style: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Color.fromRGBO(65, 64, 93, 1),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final acService = services.firstWhere(
                                    (s) => s.name == 'Appliance',
                                  );
                                  await Get.to(
                                    () => SubServicePage(service: acService),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.17,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.17,
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
                                        fontSize: 11,
                                        color: Color.fromRGBO(65, 64, 93, 1),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ServicePage(),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.17,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.17,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(223, 245, 255, 1),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "See All",
                                      style: GoogleFonts.interTight(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        color: Color.fromRGBO(65, 64, 93, 1),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.05,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final acService = services.firstWhere(
                                (s) => s.name == 'Cleaning Service',
                              );
                              await Get.to(
                                () => SubServicePage(service: acService),
                              );
                            },

                            child: Container(
                              height: 35,
                              width: 80,
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                              child: GestureDetector(
                                onTap: () {
                                  SubService homeCleaningService = SubService(
                                    id: "1",
                                    name: "Home Cleaning",
                                    description:
                                        "Complete cleaning service for your home.",
                                    image:
                                        "assets/subservice/cleaning/home_cleaning.png",
                                    price: 299,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SubServiceDetailPage(
                                            subService: homeCleaningService,
                                          ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    isLoading
                                        ? CardLoading(
                                          height: 140,
                                          width: 154,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        )
                                        : SizedBox(
                                          height: 140,
                                          width: 154,
                                          child: Image.asset(
                                            "assets/subservice/cleaning/home_cleaning.png",
                                          ),
                                        ),
                                    SizedBox(height: 8),
                                    isLoading
                                        ? SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: CardLoading(
                                            height: 100,
                                            width: 100,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
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
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: 190,
                              width: 140,
                              child: GestureDetector(
                                onTap: () {
                                  SubService homeCleaningService = SubService(
                                    id: "2",
                                    name: "Carpet Cleaning",
                                    description:
                                        "Complete cleaning service for your carpet.",
                                    image:
                                        "assets/homescreen/Mask Group (1).png",
                                    price: 799,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SubServiceDetailPage(
                                            subService: homeCleaningService,
                                          ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    isLoading
                                        ? CardLoading(
                                          height: 140,
                                          width: 154,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: 190,
                              width: 140,
                              child: GestureDetector(
                                onTap: () {
                                  SubService homeCleaningService = SubService(
                                    id: "3",
                                    name: "Bathroom Cleaning",
                                    description:
                                        "Complete bathroom and toilet cleaning",
                                    image:
                                        "assets/subservice/cleaning/faucet_bathroom_cleaning.png",
                                    price: 299,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SubServiceDetailPage(
                                            subService: homeCleaningService,
                                          ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    isLoading
                                        ? CardLoading(
                                          height: 140,
                                          width: 154,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        )
                                        : SizedBox(
                                          height: 140,
                                          width: 154,
                                          child: Image.asset(
                                            "assets/subservice/cleaning/faucet_bathroom_cleaning.png",
                                          ),
                                        ),
                                    SizedBox(height: 8),
                                    isLoading
                                        ? CardLoading(
                                          height: 15,
                                          width: 100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        )
                                        : Text(
                                          " Bathroom Cleaning",
                                          style: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                  ],
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

            ///
            ///
            ///
            ///
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(selectedIndex: 0),
    );
  }

  Widget offerCard({
  required Color bgColor,
  required String title,
  required String discount,
  required Color buttonColor,
  required Color highColor,
  required String couponCode, // 👈 Optional coupon code
}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      height: MediaQuery.sizeOf(context).height * 0.25,
      width: 289,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black87, blurRadius: 9, spreadRadius: 0.5)
        ],
      ),
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: bgColor,
            highlightColor: highColor,
            direction: ShimmerDirection.btt,
            loop: 0,
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          Padding(
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
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.info_rounded, size: 20, color: Colors.black),
                  ],
                ),
                Text(
                  discount,
                  style: GoogleFonts.interTight(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                // const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: couponCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coupon code "$couponCode" copied!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    height: 29,
                    width: MediaQuery.sizeOf(context).width * 0.30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black54,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Grab Offer",
                          style: GoogleFonts.interTight(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.copy,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
