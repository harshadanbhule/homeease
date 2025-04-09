import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:homease/Custom/custom_appbar.dart';
import 'package:homease/Custom/custom_nav_bar.dart';
import 'package:homease/Pages/booking.dart';
import 'package:homease/Pages/chatbot.dart';
import 'package:homease/Pages/homepage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shimmer/shimmer.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomNavBar(selectedIndex: 1),
       body: Text("Booking"),
    );
  }
}