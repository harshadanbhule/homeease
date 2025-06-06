// lib/services/fire_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireService {
  static Future<String> getFullNameFromUserLocations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 'User';

      final snapshot = await FirebaseFirestore.instance
          .collection('user_locations')
          .where('phoneNumber', isEqualTo: user.phoneNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final firstName = data['firstName'] ?? '';
        final lastName = data['lastName'] ?? '';
        return '$firstName $lastName';
      } else {
        return 'User';
      }
    } catch (e) {
      return 'User';
    }
  }
}
