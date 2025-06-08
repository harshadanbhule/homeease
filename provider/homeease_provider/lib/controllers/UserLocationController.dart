import 'package:get/get.dart';
import 'package:homeease_provider/DataBase/user_location_model.dart';

class UserLocationController extends GetxController {
  var userLocation = Rxn<UserLocationModel>();

  void setUserLocation(UserLocationModel location) {
    userLocation.value = location;
  }

  UserLocationModel? get data => userLocation.value;
}
