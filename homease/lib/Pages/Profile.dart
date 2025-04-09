import 'package:flutter/material.dart';
import 'package:homease/Custom/custom_appbar.dart';
import 'package:homease/Custom/custom_nav_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomNavBar(selectedIndex: 3),
      body: Text("Profile"),
    );
  }
}