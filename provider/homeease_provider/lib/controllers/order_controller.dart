import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class OrderDetails {
  final OrderModel order;
  final UserModel user;

  OrderDetails({required this.order, required this.user});
}

class OrderController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<OrderDetails>> fetchAllOrders() async {
    final orderSnapshot = await firestore.collection('orders').get();
    List<OrderDetails> orderDetailsList = [];

    for (var doc in orderSnapshot.docs) {
      final order = OrderModel.fromMap(doc.id, doc.data());

      final locationDoc = await firestore
          .collection('user_locations')
          .doc(order.userId)
          .get();

      if (!locationDoc.exists) continue;

      final locationData = locationDoc.data()!;
      final user = UserModel.fromMap(locationData);

      orderDetailsList.add(OrderDetails(order: order, user: user));
    }

    return orderDetailsList;
  }
}
