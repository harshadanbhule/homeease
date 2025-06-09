import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

              return  Container(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
    ],
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 5,
      ),
      Column(
        children: [
          SizedBox(height: 5,),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              topRight:Radius.circular(16),
              bottomRight: Radius.circular(16), 
            ),
            child: matchedSubService != null
                ? Image.asset(
                    matchedSubService.image,
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.width * 0.28,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.width * 0.28,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
          ),
        ],
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Service: $subServiceName",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Qty: ${order['quantity']}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "Total: ₹${order['totalAmount']}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "Date: $formattedDate",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "Time: ${order['bookingTime']}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      )
    ],
  ),
);

            },
          );
        },
      ),
    );
  }
}
