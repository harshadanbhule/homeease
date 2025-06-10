import 'package:flutter/material.dart';
import 'package:homeease_provider/Custom/custom_appbar.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';
import 'package:homeease_provider/controllers/userDetail_controller.dart';
import 'package:homeease_provider/pages/order_details_page.dart';
import '../controllers/order_controller.dart';
import '../services/call_service.dart';
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
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
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
            
            final pathParts = serviceImage.split('/');
            if (pathParts.length >= 3) {
              final serviceType = pathParts[2];
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

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color:const Color.fromRGBO(100, 27, 180, 1),
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pending_actions,color: Colors.white,),
                            SizedBox(width: 2),
                            Text('Pending Orders',style: TextStyle(color: Colors.white),),
                            if (pendingOrders.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${pendingOrders.length}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,color: Colors.white,),
                            SizedBox(width: 1),
                            Text('Accepted Orders',style: TextStyle(color: Colors.white),),
                            if (acceptedOrders.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(left: 1),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${acceptedOrders.length}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Pending Orders Tab
                      pendingOrders.isEmpty
                          ? Center(child: Text('No pending orders'))
                          : ListView.builder(
                              itemCount: pendingOrders.length,
                              itemBuilder: (context, index) {
                                return _buildOrderCard(pendingOrders[index]);
                              },
                            ),
                      // Accepted Orders Tab
                      acceptedOrders.isEmpty
                          ? Center(child: Text('No accepted orders'))
                          : ListView.builder(
                              itemCount: acceptedOrders.length,
                              itemBuilder: (context, index) {
                                return _buildOrderCard(acceptedOrders[index]);
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(selectedIndex: 1),
    );
  }

Widget _buildOrderCard(OrderDetails orderDetail) {
  final order = orderDetail.order;
  final user = orderDetail.user;
  final callService = CallService();

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    elevation: 4,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top: Image and Basic Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Service Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    order.serviceImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                /// Order Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.serviceName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Customer: ${user.fullName}',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Quantity: ${order.quantity}',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Total: ₹${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Status Badge
                if (order.isAccepted)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Accepted',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 12),

            /// Location
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.redAccent),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    user.fullLocation,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            /// Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.blueAccent),
                SizedBox(width: 6),
                Text(
                  'Ordered on: ${order.createdAt}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),

            if (order.isAccepted) ...[
              SizedBox(height: 12),

              /// Phone + Call Button Section
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  border: Border.all(color: Colors.green.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user.phoneNumber,
                        style: TextStyle(
                          color: Colors.green[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await callService.startCall(user.phoneNumber);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to start call: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.call, size: 16),
                      label: Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}


}