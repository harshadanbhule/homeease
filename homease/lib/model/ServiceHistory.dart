import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceHistory {
  final String serviceName;
  final double price;
  final DateTime date;
  final String propertyType;
  final int numberOfServices;
  final String description;
  final List<Map<String, dynamic>> items; // Cart items

  ServiceHistory({
    required this.serviceName,
    required this.price,
    required this.date,
    required this.propertyType,
    required this.numberOfServices,
    required this.description,
    required this.items,
  });

  factory ServiceHistory.fromMap(Map<String, dynamic> map) {
    return ServiceHistory(
      serviceName: map['serviceName'],
      price: map['price'],
      date: (map['date'] as Timestamp).toDate(),
      propertyType: map['propertyType'],
      numberOfServices: map['numberOfServices'],
      description: map['description'],
      items: List<Map<String, dynamic>>.from(map['items']),
    );
  }
}
