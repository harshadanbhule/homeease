import 'package:flutter/material.dart';
import 'package:homeease_provider/Custom/custom_appbar.dart';
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
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              const Text(
                'Welcome, Partner 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Here’s your job summary for today.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Status Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusCard('Pending', '3', Colors.orange),
                  _buildStatusCard('Completed', '8', Colors.green),
                  _buildStatusCard('Earnings', '₹2,150', Colors.blue),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Actions
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

              // Recent Requests
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
      ),
    );
  }

  // Status Card Widget
  Widget _buildStatusCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick Action Button
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

  // Request Tile
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