import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/Custom/custom_appbar.dart';
import 'package:homease/Custom/custom_nav_bar.dart';
import 'package:homease/Pages/Profile/editProf.dart';
import 'package:homease/Pages/Profile/editadd.dart';
import 'package:homease/Pages/Profile/invite.dart';
import 'package:homease/controllers/location_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final locationController = Get.find<LocationController>();
  String email = '';

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        email = user.email ?? '';
      });

      final doc = await FirebaseFirestore.instance
          .collection('user_locations')
          .doc(user.uid)
          .get();

      final data = doc.data();
      if (data != null) {
        final lat = data['coordinates']['latitude'];
        final lng = data['coordinates']['longitude'];
        final placemarks = await placemarkFromCoordinates(lat, lng);
        final place = placemarks.first;
        locationController.updateLocation("${place.street}, ${place.locality}");

        final firstName = data['firstName'] ?? '';
        final lastName = data['lastName'] ?? '';
        final fullName = "$firstName $lastName";
        locationController.updateFullName(fullName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomNavBar(selectedIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            'Hello ${locationController.fullName.value}',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(35, 51, 74, 1),
                            ),
                          )),
                      const SizedBox(height: 4),
                      Text(
                        email.isNotEmpty ? email : 'Loading email...',
                        style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFF5F5F5),
                  child: Icon(Icons.person, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Invite card
            GestureDetector(
              onTap: () => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const InvitePage()),
),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(249, 249, 249, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite your friends & get up to ₹100',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color.fromRGBO(35, 51, 74, 1),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Introduce your friends to the easiest way to find and hire professionals for your needs.',
                      style:GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            
            GestureDetector(
              onTap: () => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const EditProfilePage()),
),

              child: _buildMenuItem(Icons.person, 'Edit Profile', Color.fromRGBO(37, 183, 211, 1))),
            GestureDetector(
              onTap: () => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const Editadd()),
),

              child: _buildMenuItem(Icons.location_on, 'Saved Addresses', Color.fromRGBO(51, 122, 251, 1))),
            _buildMenuItem(Icons.notifications, 'Notifications', Color.fromRGBO(82, 102, 141, 1)),
            _buildMenuItem(Icons.favorite, "Saved Services", Color.fromRGBO(248, 79, 49, 1)),
            _buildMenuItem(Icons.star, 'Rate our app', Color.fromRGBO(100, 27, 180, 1)),
            _buildMenuItem(Icons.info, 'About Us', Color.fromRGBO(100, 27, 180, 1)),

            const SizedBox(height: 40),
            Center(
              child: Text(
                'Version 1.0.0',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Color.fromRGBO(35, 51, 74, 1),
            ),
          ),
        ],
      ),
    );
  }
}
