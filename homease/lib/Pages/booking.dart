import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/Custom/custom_appbar.dart';
import 'package:homease/Custom/custom_nav_bar.dart';
import 'package:homease/model/sub_service_model.dart';
import 'package:homease/service%20data/service_data.dart';
import 'package:intl/intl.dart';
import 'package:homease/Pages/provider_location.dart';

class Booking extends StatelessWidget {
  const Booking({super.key});

  Widget _buildOrderCard(BuildContext context, var order, SubService? matchedSubService) {
    String subServiceName = order['serviceName'];
    String bookingDateString = order['bookingDate'];
    DateTime bookingDate = DateTime.tryParse(bookingDateString) ?? DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(bookingDate);

    return Container(
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
          const SizedBox(width: 5),
          Column(
            children: [
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
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
  }

  SubService? _findMatchingSubService(String subServiceName) {
    for (var service in services) {
      for (var sub in service.subServices) {
        if (sub.name == subServiceName) {
          return sub;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomNavBar(selectedIndex: 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pending Orders Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Pending Orders",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs;
                if (orders.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No pending orders",
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    String subServiceName = order['serviceName'];
                    SubService? matchedSubService = _findMatchingSubService(subServiceName);
                    return _buildOrderCard(context, order, matchedSubService);
                  },
                );
              },
            ),

            // Accepted Orders Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Accepted Orders",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders_acceptedmain')
                  .where('customerId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs;
                if (orders.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No accepted orders",
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index].data() as Map<String, dynamic>;
                    String subServiceName = order['serviceName'] ?? '';
                    String serviceImage = order['orderDetails']?['serviceImage'] ?? '';
                    int quantity = order['quantity'] ?? 0;
                    double totalAmount = (order['totalAmount'] ?? 0).toDouble();
                    String status = order['status'] ?? '';

                    return GestureDetector(
                      onTap: () async {
                        try {
                          // Get provider details from worker_locations using workerId
                          var providerDoc = await FirebaseFirestore.instance
                              .collection('worker_locations')
                              .doc(order['workerId'])
                              .get();
                          
                          if (providerDoc.exists) {
                            var providerData = providerDoc.data() as Map<String, dynamic>;
                            String firstName = providerData['firstName'] ?? '';
                            String lastName = providerData['lastName'] ?? '';
                            String phoneNumber = providerData['phoneNumber'] ?? '';
                            String serviceName = providerData['serviceName'] ?? '';
                            
                            // Combine first and last name
                            String providerName = '$firstName $lastName'.trim();
                            
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProviderLocation(
                                  providerName: providerName,
                                  phoneNumber: phoneNumber,
                                  orderId: order['orderId'] ?? '',
                                  providerId: order['workerId'] ?? '',
                                  serviceName: serviceName,
                                  quantity: order['quantity'] ?? 0,
                                  totalAmount: (order['totalAmount'] ?? 0).toDouble(),
                                  status: order['status'] ?? '',
                                ),
                              ),
                            );
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Provider details not found')),
                            );
                          }
                        } catch (e) {
                          print('Error accessing worker details: $e'); // Debug print
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                      child: Container(
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
                            const SizedBox(width: 5),
                            Column(
                              children: [
                                const SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                                  child: Image.asset(
                                    serviceImage,
                                    width: MediaQuery.of(context).size.width * 0.28,
                                    height: MediaQuery.of(context).size.width * 0.28,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width * 0.28,
                                        height: MediaQuery.of(context).size.width * 0.28,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image_not_supported),
                                      );
                                    },
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
                                      "Qty: $quantity",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      "Total: ₹$totalAmount",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      "Status: $status",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Tap to view provider details",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
