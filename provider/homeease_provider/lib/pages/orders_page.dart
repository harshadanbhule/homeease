import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 27, 180, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Obx(() {
          return Text(
            userDetailController.serviceName.value,
            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.w600),
          );
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
                            SizedBox(width: 8),
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
                            SizedBox(width: 8),
                            Text('Accepted Orders',style: TextStyle(color: Colors.white),),
                            if (acceptedOrders.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(left: 8),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.serviceName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (order.isAccepted)
                    Container(
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
              SizedBox(height: 12),
              Text("Name: ${user.fullName}"),
              if (order.isAccepted) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Phone: ${user.phoneNumber}",
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
                        icon: Icon(Icons.call, color: Colors.white),
                        label: Text('Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 8),
              Text("Location: ${user.fullLocation}"),
              Text("Coordinates: ${user.coordinates?.latitude ?? 'N/A'}, ${user.coordinates?.longitude ?? 'N/A'}"),
              Text("Quantity: ${order.quantity}"),
              Text("Total: ₹${order.totalAmount.toStringAsFixed(2)}"),
              Text("Ordered on: ${order.createdAt}"),
              Text("serviceImage : ${order.serviceImage}"),
            ],
          ),
        ),
      ),
    );
  }
}