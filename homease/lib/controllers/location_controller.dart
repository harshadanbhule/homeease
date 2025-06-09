import 'package:get/get.dart';

class LocationController extends GetxController {
  var userLocation = "Fetching location...".obs;
  var fullName = "Loading name...".obs;

  void updateLocation(String newLocation) {
    userLocation.value = newLocation;
  }

  void updateFullName(String name) {
    fullName.value = name;
  }
}
