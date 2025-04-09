
import 'package:get/get.dart';



class LocationController extends GetxController {
  var userLocation = "Fetching location...".obs;

  void updateLocation(String newLocation) {
    userLocation.value = newLocation;
  }
}
