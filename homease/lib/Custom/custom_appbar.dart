// lib/Custom/custom_appbar.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/location_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();

    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 72,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(CupertinoIcons.placemark, color: Colors.black),
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
                Obx(() => Text(
                      locationController.userLocation.value,
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: const Color.fromRGBO(23, 43, 77, 1),
                      ),
                    )),
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
    );
  }
}
