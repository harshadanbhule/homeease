import 'package:flutter/material.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:CustomNavBar(selectedIndex: 0),
    );
  }
}