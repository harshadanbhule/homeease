import 'package:latlong2/latlong.dart';

class UserLocationModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String education;
  final List<String> languageList;
  final String serviceName;
  final String workLocation;
  final LatLng currentPosition;
  final LatLng coordinates;
  final String address;

  final String building;
  final String? apartment;
  final String? floor;
  final String street;
  final bool isHome;

  UserLocationModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.education,
    required this.languageList,
    required this.serviceName,
    required this.workLocation,
    required this.currentPosition,
    required this.coordinates,
    required this.address,
    required this.building,
    this.apartment,
    this.floor,
    required this.street,
    required this.isHome,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'education': education,
      'languageList': languageList,
      'serviceName': serviceName,
      'workLocation': workLocation,
      'currentPosition': {
        'latitude': currentPosition.latitude,
        'longitude': currentPosition.longitude,
      },
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
      'address': address,
      'building': building,
      'apartment': apartment,
      'floor': floor,
      'street': street,
      'isHome': isHome,
    };
  }
}
