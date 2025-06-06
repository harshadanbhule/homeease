import 'package:flutter/material.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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

          if (orders.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDetail = orders[index];
              final order = orderDetail.order;
              final user = orderDetail.user;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(order.serviceName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${user.fullName}"),
                      Text("Location: ${user.fullLocation}"),
                      Text("Quantity: ${order.quantity}"),
                      Text("Total: ₹${order.totalAmount.toStringAsFixed(2)}"),
                      Text("Ordered on: ${order.createdAt}"),
                      Text("serviceImage : ${order.serviceImage}")
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
