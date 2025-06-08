import 'package:flutter/material.dart';
import 'package:homeease_provider/Pages/homepage.dart';
import 'package:shimmer/shimmer.dart';

class ShimarPage extends StatefulWidget {
  const ShimarPage({super.key});

  @override
  State<ShimarPage> createState() => _ShimarPageState();
}

class _ShimarPageState extends State<ShimarPage> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    try {
      // Simulate loading user data or any async task:
      await Future.delayed(const Duration(seconds: 3)); // simulate data load

      // You can replace above with your actual loading logic, e.g.:
      // final uid = FirebaseAuth.instance.currentUser?.uid;
      // await Get.find<UserLocationController>().loadUserLocation(uid);

    } catch (e) {
      print("Error during initialization: $e");
    }

    // Optional extra delay so shimmer stays a bit longer
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => Homepage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _rect(width: size.width * 0.5, height: 15),
                    _rect(width: 80, height: 15),
                  ],
                ),
                const SizedBox(height: 30),

                _rect(width: size.width * 0.4, height: 15),
                const SizedBox(height: 30),

                _rect(width: size.width * 0.7, height: 30),
                const SizedBox(height: 40),

                _roundedRect(height: 50),
                const SizedBox(height: 35),

                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, __) => _roundedRect(width: 220, height: 120),
                  ),
                ),
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (index) => Column(
                      children: [
                        _circle(width: 60),
                        const SizedBox(height: 8),
                        _rect(width: 40, height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _rect(width: size.width * 0.4, height: 15),
                    _rect(width: 50, height: 15),
                  ],
                ),
                const SizedBox(height: 46),

                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, __) => _roundedRect(width: 100, height: 120),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rect({double width = double.infinity, double height = 16}) {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
    );
  }

  Widget _roundedRect({double width = double.infinity, double height = 100}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _circle({double width = 60}) {
    return Container(
      width: width,
      height: width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}

// Dummy Homepage for navigation target

