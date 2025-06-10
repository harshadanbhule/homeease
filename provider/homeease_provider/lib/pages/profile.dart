//profile.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';
import 'package:homeease_provider/controllers/UserProfileController.dart';
import 'package:homeease_provider/pages/edit_profile_page.dart';
import 'package:homeease_provider/pages/invite.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserProfileController userProfileController = Get.put(UserProfileController());
  String email = '';

  @override
  void initState() {
    super.initState();
    loadEmail();
  }

  Future<void> loadEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? '';
      });
      await userProfileController.fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Profile', style: GoogleFonts.poppins(color: Colors.black)),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomNavBar(selectedIndex: 3),
      body: Obx(() {
        if (userProfileController.userData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = userProfileController.userData;
        final fullName = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello $fullName',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color.fromRGBO(35, 51, 74, 1),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email.isNotEmpty ? email : 'Loading email...',
                          style: const TextStyle(
                            color: Color.fromRGBO(119, 119, 119, 1),
                          ),
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
                        'Introduce your friends to the easiest way to manage orders.',
                        style: GoogleFonts.poppins(color: Colors.grey),
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
                child: _buildMenuItem(Icons.person, 'Edit Profile', Color.fromRGBO(37, 183, 211, 1)),
              ),
              _buildMenuItem(Icons.notifications, 'Notifications', Color.fromRGBO(82, 102, 141, 1)),
              _buildMenuItem(Icons.star, 'Rate our app', const Color.fromRGBO(100, 27, 180, 1)),
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
        );
      }),
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