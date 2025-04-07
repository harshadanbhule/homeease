// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user_locations');

  Future<void> saveUserData({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String building,
    required String apartment,
    required String street,
    required String address,
    required double latitude,
    required double longitude,
    required bool isHome,
  }) async {
    await userCollection.add({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'building': building,
      'apartment': apartment,
      'street': street,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isHome': isHome,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
