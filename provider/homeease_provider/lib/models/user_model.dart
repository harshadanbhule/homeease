import 'package:latlong2/latlong.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String building;
  final String? apartment;
  final String street;
  final bool isHome;
  final LatLng? coordinates;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.building,
    required this.apartment,
    required this.street,
    required this.isHome,
    this.coordinates,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      building: data['building'] ?? '',
      apartment: data['apartment'],
      street: data['street'] ?? '',
      isHome: data['isHome'] ?? false,
      coordinates: data['coordinates'] != null ? LatLng(
        data['coordinates']['latitude'] ?? 0.0,
        data['coordinates']['longitude'] ?? 0.0,
      ) : null,
    );
  }

  String get fullName => '$firstName $lastName';

  String get fullLocation {
    return "$building${apartment != null ? ', Apt $apartment' : ''}, $street, $address";
  }
}
