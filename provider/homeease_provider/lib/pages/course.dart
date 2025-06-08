import 'package:flutter/material.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';

class Course extends StatefulWidget {
  const Course({super.key});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:CustomNavBar(selectedIndex: 2),
    );
  }
}