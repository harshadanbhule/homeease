import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';
import 'package:homeease_provider/controllers/UserProfileController.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserProfileController userProfileController = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Obx(() {
        if (userProfileController.userData.isEmpty) {
          return const Center(child: Text("No data found or loading..."));
        }

        final data = userProfileController.userData;

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('First Name: ${data['firstName'] ?? ''}'),
            Text('Last Name: ${data['lastName'] ?? ''}'),
            Text('Phone Number: ${data['phoneNumber'] ?? ''}'),
            Text('Education: ${data['education'] ?? ''}'),
            Text('Service Name: ${data['serviceName'] ?? ''}'),
            Text('Work Location: ${data['workLocation'] ?? ''}'),
            // Add more fields as per your data structure
          ],
        );
      }),
      bottomNavigationBar: CustomNavBar(selectedIndex: 3),
    );
  }
}
