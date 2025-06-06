import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String serviceName;
  final String userId;
  final int quantity;
  final double totalAmount;
  final DateTime createdAt;
  final String serviceImage;

  OrderModel({
    required this.id,
    required this.serviceName,
    required this.userId,
    required this.quantity,
    required this.totalAmount,
    required this.createdAt,
    required this.serviceImage
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> data) {
    return OrderModel(
      id: id,
      serviceName: data['serviceName'] ?? 'No Service Name',
      userId: data['userId'] ?? '',
      quantity: data['quantity'] ?? 0,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceImage: data['serviceImage'] as String? ?? '',

    );
  }
}
