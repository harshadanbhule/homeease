import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileController extends GetxController {
  // You can create a model for better structure; for now, simple Map:
  var userData = <String, dynamic>{}.obs;

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      userData.value = {};
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('worker_locations')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      userData.value = doc.data()!;
    } else {
      userData.value = {};
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }
}
