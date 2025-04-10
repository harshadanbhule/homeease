import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:homease/Custom/custom_appbar.dart';
import 'package:homease/Custom/custom_nav_bar.dart';
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
                            'HELLO ${locationController.fullName.value.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2B3B),
                            ),
                          )),
                      const SizedBox(height: 4),
                      Text(
                        email.isNotEmpty ? email : 'Loading email...',
                        style: const TextStyle(color: Colors.grey),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite your friends & get up to ₹100',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1E2B3B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Introduce your friends to the easiest way to find and hire professionals for your needs.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            
            _buildMenuItem(Icons.person, 'Edit Profile', Colors.blue),
            _buildMenuItem(Icons.location_on, 'Saved Addresses', Colors.indigo),
            _buildMenuItem(Icons.notifications, 'Notifications', Colors.deepOrange),
            _buildMenuItem(Icons.favorite, "Saved Skillr’s", Colors.purple),
            _buildMenuItem(Icons.star, 'Rate our app', Colors.amber),
            _buildMenuItem(Icons.info, 'About Us', Colors.cyan),

            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey),
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
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1E2B3B),
            ),
          ),
        ],
      ),
    );
  }
}
