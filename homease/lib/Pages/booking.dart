import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homease/Custom/custom_appbar.dart';
import 'package:homease/Custom/custom_nav_bar.dart';
import 'package:homease/model/sub_service_model.dart';
import 'package:homease/service%20data/service_data.dart';
import 'package:intl/intl.dart';

class Booking extends StatelessWidget {
  const Booking({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomNavBar(selectedIndex: 1),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              String subServiceName = order['serviceName'];
              String bookingDateString = order['bookingDate'];

              // Parse the string to DateTime
              DateTime bookingDate = DateTime.tryParse(bookingDateString) ?? DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd').format(bookingDate);

              SubService? matchedSubService;
              for (var service in services) {
                for (var sub in service.subServices) {
                  if (sub.name == subServiceName) {
                    matchedSubService = sub;
                    break;
                  }
                }
                if (matchedSubService != null) break;
              }

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: matchedSubService != null
                      ? Image.asset(
                          matchedSubService.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text("Service: $subServiceName"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Qty: ${order['quantity']}"),
                      Text("Total: ₹${order['totalAmount']}"),
                      Text("Date: $formattedDate"),
                      Text("Time: ${order['bookingTime']}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
