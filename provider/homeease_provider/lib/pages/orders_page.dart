import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';
import 'package:homeease_provider/controllers/UserLocationController.dart';
import 'package:homeease_provider/controllers/order_controller.dart';
import 'package:homeease_provider/models/order_model.dart';
import 'package:homeease_provider/models/user_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderController controller = OrderController();
  final UserLocationController userLocationController = Get.find<UserLocationController>();

  late Future<List<OrderDetails>> _orderDetailsFuture;

  @override
  void initState() {
    super.initState();
    _orderDetailsFuture = controller.fetchAllOrders();
  }

  // Extracts category from path like "assets/subservice/beauty/pedicure.png"
  String extractCategoryFromPath(String path) {
    try {
      final parts = path.split('/');
      if (parts.length >= 3) {
        return parts[2].toLowerCase(); // e.g., "beauty"
      }
    } catch (e) {
      print("Error parsing path: $e");
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Orders")),
      body: FutureBuilder<List<OrderDetails>>(
        future: _orderDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final orders = snapshot.data ?? [];
          final userData = userLocationController.data;

          if (userData == null) {
            return const Center(child: Text("User data not available"));
          }

          final userCategory = userData.serviceName.toLowerCase();

          final filteredOrders = orders.where((orderDetail) {
            final orderCategory = extractCategoryFromPath(orderDetail.order.serviceImage);
            return orderCategory == userCategory;
          }).toList();

          if (filteredOrders.isEmpty) {
            return Center(child: Text("No orders found for category: $userCategory"));
          }

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final orderDetail = filteredOrders[index];
              final order = orderDetail.order;
              final user = orderDetail.user;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.serviceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Name: ${user.fullName}"),
                      Text("Location: ${user.fullLocation}"),
                      Text("Quantity: ${order.quantity}"),
                      Text("Total: ₹${order.totalAmount.toStringAsFixed(2)}"),
                      Text("Ordered on: ${order.createdAt}"),
                      const SizedBox(height: 8),
                      if (order.serviceImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            order.serviceImage,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Text("Image not found"),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar:CustomNavBar(selectedIndex: 1),
    );
  }
}
