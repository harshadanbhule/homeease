import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeease_provider/Custom/custom_appbar.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';
import 'package:homeease_provider/controllers/UserProfileController.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final UserProfileController userProfileController = Get.put(UserProfileController());

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await userProfileController.fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
      body: Obx(() {
        if (userProfileController.userData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = userProfileController.userData;
        final fullName = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}";

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HELLO ${fullName.toUpperCase()} 👋",
                          style: GoogleFonts.inter(
                            letterSpacing: 1.5,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(102, 108, 137, 1),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "What you are looking for today",
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: const Color.fromRGBO(23, 43, 77, 1),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 60,
                          child: TextField(
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                  "assets/homescreen/Group 34308.svg",
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: const Color.fromRGBO(248, 248, 248, 1),
                              filled: true,
                              hintText: "Search what you need...",
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 8),
                const Text(
                  'Here’s your job summary for today.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(Icons.play_circle_fill, 'Start Job'),
                    _buildActionButton(Icons.calendar_today, 'Schedule'),
                    _buildActionButton(Icons.support_agent, 'Support'),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  'Recent Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _buildRequestTile('AC Cleaning', '10:30 AM', 'Pending'),
                _buildRequestTile('Plumbing', '1:00 PM', 'Completed'),
                _buildRequestTile('Beauty', '4:00 PM', 'Scheduled'),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.deepPurple.withOpacity(0.1),
          child: Icon(icon, size: 30, color: Colors.deepPurple),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildRequestTile(String service, String time, String status) {
    Color statusColor = status == 'Pending'
        ? Colors.orange
        : status == 'Completed'
            ? Colors.green
            : Colors.blue;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.build_circle, size: 32, color: Colors.deepPurple),
        title: Text(service),
        subtitle: Text('Scheduled at $time'),
        trailing: Chip(
          label: Text(status),
          backgroundColor: statusColor.withOpacity(0.2),
          labelStyle: TextStyle(color: statusColor),
        ),
      ),
    );
  }
}
