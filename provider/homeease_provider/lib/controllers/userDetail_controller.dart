import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailController extends GetxController {
  var serviceName = ''.obs;  // single service name as observable string

  Future<void> fetchServiceNameForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      serviceName.value = 'No user logged in';
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('worker_locations')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      serviceName.value = data['serviceName'] ?? 'No service name found';
    } else {
      serviceName.value = 'Document not found';
    }
  }
  
  @override
  void onInit() {
    super.onInit();
    fetchServiceNameForCurrentUser();
  }
}
