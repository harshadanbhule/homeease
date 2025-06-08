import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:CustomNavBar(selectedIndex: 3),
    );
  }
}