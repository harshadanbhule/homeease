import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLocationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserFullName() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        print("❌ No user is logged in.");
        return null;
      }

      // Change this to user.uid once you use actual user-based documents
      final String testDocId = "Cmc82X2oD6cLPiuBDI6A5f304p42";

      final docRef = _firestore.collection('user_locations').doc(testDocId);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final data = docSnap.data();
        final firstName = data?['firstName'] ?? '';
        final lastName = data?['lastName'] ?? '';

        final fullName = '$firstName $lastName'.trim();
        print("✅ Full Name: $fullName");
        return fullName;
      } else {
        print("❌ Document not found.");
        return null;
      }
    } catch (e) {
      print("🔥 Error fetching full name: $e");
      return null;
    }
  }
}
