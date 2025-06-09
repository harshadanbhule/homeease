import 'package:latlong2/latlong.dart';

class UserLocationModel {
  final String firstName;
  final String lastName;
  final String phoneNumber; // updated
  final String address;
  final LatLng coordinates;
  final String building;
  final String? apartment;
  final String street;
  final bool isHome;

  UserLocationModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber, // updated
    required this.address,
    required this.coordinates,
    required this.building,
    this.apartment,
    required this.street,
    required this.isHome,
  });
}
