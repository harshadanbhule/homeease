import 'package:flutter/material.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';
import 'package:homeease_provider/controllers/userDetail_controller.dart';
import 'package:homeease_provider/pages/order_details_page.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';

class OrdersPage extends StatefulWidget {
  
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final UserDetailController userDetailController = Get.put(UserDetailController());
  final OrderController controller = OrderController();
  late Future<List<OrderDetails>> _orderDetailsFuture;
  
  

  @override
void initState() {
  super.initState();
  _orderDetailsFuture = controller.fetchAllOrders();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.yellow,
        title: Obx(() {
         
            return Text( userDetailController.serviceName.value);
          
        }),
      ),
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

          if (orders.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          // Filter orders based on selected service
          final filteredOrders = orders.where((orderDetail) {
            final order = orderDetail.order;
            final serviceImage = order.serviceImage.toLowerCase();
            final selectedService = userDetailController.serviceName.value.toLowerCase();
            
            // Extract service type from path (e.g., "assets/subservice/cleaning/..." -> "cleaning")
            final pathParts = serviceImage.split('/');
            if (pathParts.length >= 3) {
              final serviceType = pathParts[2]; // Get the service type from path
              return serviceType == selectedService;
            }
            return false;
          }).toList();

          if (filteredOrders.isEmpty) {
            return Center(child: Text("No orders found for ${userDetailController.serviceName.value} service."));
          }

          // Separate accepted and pending orders
          final acceptedOrders = filteredOrders.where((order) => order.order.isAccepted).toList();
          final pendingOrders = filteredOrders.where((order) => !order.order.isAccepted).toList();

          return ListView(
            children: [
              if (acceptedOrders.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Accepted Orders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                ...acceptedOrders.map((orderDetail) => _buildOrderCard(orderDetail)),
              ],
              if (pendingOrders.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pending Orders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                ...pendingOrders.map((orderDetail) => _buildOrderCard(orderDetail)),
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildOrderCard(OrderDetails orderDetail) {
    final order = orderDetail.order;
    final user = orderDetail.user;

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                order: order,
                user: user,
              ),
            ),
          );
        },
        child: ListTile(
          title: Text(order.serviceName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${user.fullName}"),
              Text("Location: ${user.fullLocation}"),
              Text("Coordinates: ${user.coordinates?.latitude ?? 'N/A'}, ${user.coordinates?.longitude ?? 'N/A'}"),
              Text("Quantity: ${order.quantity}"),
              Text("Total: ₹${order.totalAmount.toStringAsFixed(2)}"),
              Text("Ordered on: ${order.createdAt}"),
              Text("serviceImage : ${order.serviceImage}"),
              if (order.isAccepted)
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Accepted',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}