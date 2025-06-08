import 'package:get/get.dart';
import 'package:homeease_provider/DataBase/user_location_model.dart';

class UserLocationController extends GetxController {
  // Observable model
  final Rxn<UserLocationModel> _userLocation = Rxn<UserLocationModel>();

  // Setter
  void setUserLocation(UserLocationModel location) {
    _userLocation.value = location;
  }

  // Getter
  UserLocationModel? get data => _userLocation.value;

  // Optional: Add an observable getter for reactive widgets
  Rxn<UserLocationModel> get userLocation => _userLocation;
}
