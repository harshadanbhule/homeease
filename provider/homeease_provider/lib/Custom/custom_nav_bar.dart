// lib/widgets/custom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:homeease_provider/Pages/homepage.dart';
import 'package:homeease_provider/pages/course.dart';
import 'package:homeease_provider/pages/orders_page.dart';
import 'package:homeease_provider/pages/profile.dart';

import 'package:line_icons/line_icons.dart';
import 'package:shimmer/shimmer.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  const CustomNavBar({super.key, required this.selectedIndex});

  void _navigateToPage(BuildContext context, int index) {
    if (index == selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Homepage()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => OrdersPage()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Course()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Profile()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: GNav(
          activeColor: Colors.white,
          backgroundColor: Colors.transparent,
          haptic: true,
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.black, width: 0.1),
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 300),
          gap: 8,
          iconSize: MediaQuery.of(context).size.width < 400 ? 22 : 26,
          tabBackgroundColor: const Color.fromRGBO(100, 27, 180, 1),
          padding: MediaQuery.of(context).size.width < 400
              ? const EdgeInsets.symmetric(horizontal: 15, vertical: 8)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          selectedIndex: selectedIndex,
          onTabChange: (index) => _navigateToPage(context, index),
          tabs: [
            GButton(
              icon: Icons.circle,
              iconColor: Colors.transparent,
              leading: Shimmer.fromColors(
                baseColor: selectedIndex == 0 ? Colors.white : Colors.black,
                highlightColor: Colors.grey.shade300,
                child: const Icon(LineIcons.home, size: 26),
              ),
              text: 'Home',
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
            ),
            GButton(
              icon: Icons.circle,
              iconColor: Colors.transparent,
              leading: Shimmer.fromColors(
                baseColor: selectedIndex == 1 ? Colors.white : Colors.black,
                highlightColor: Colors.grey.shade300,
                child: const Icon(LineIcons.book, size: 26),
              ),
              text: 'Bookings',
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
            ),
            GButton(
              icon: Icons.circle,
              iconColor: Colors.transparent,
              leading: Shimmer.fromColors(
                baseColor: selectedIndex == 2 ? Colors.white : Colors.black,
                highlightColor: Colors.grey.shade300,
                child: SvgPicture.asset(
                  "assets/homescreen/1538298822.svg",
                  height: 30,
                  width: 30,
                  color: selectedIndex == 2 ? Colors.white : Colors.black,
                ),
              ),
              text: 'ChatBot',
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
            ),
            GButton(
              icon: Icons.circle,
              iconColor: Colors.transparent,
              leading: Shimmer.fromColors(
                baseColor: selectedIndex == 3 ? Colors.white : Colors.black,
                highlightColor: Colors.grey.shade300,
                child: const Icon(LineIcons.user, size: 26),
              ),
              text: 'Profile',
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
