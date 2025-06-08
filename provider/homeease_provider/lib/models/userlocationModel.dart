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
  final String? building;
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
    this.building,
    this.apartment,
    this.floor,
    required this.street,
    required this.isHome,
  });

  factory UserLocationModel.fromMap(Map<String, dynamic> map) {
    return UserLocationModel(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      education: map['education'] ?? '',
      languageList: List<String>.from(map['languageList'] ?? []),
      serviceName: map['serviceName'] ?? '',
      workLocation: map['workLocation'] ?? '',
      currentPosition: LatLng(
        map['currentPosition']['latitude'] ?? 0.0,
        map['currentPosition']['longitude'] ?? 0.0,
      ),
      coordinates: LatLng(
        map['coordinates']['latitude'] ?? 0.0,
        map['coordinates']['longitude'] ?? 0.0,
      ),
      address: map['address'] ?? '',
      building: map['building'],
      apartment: map['apartment'],
      floor: map['floor'],
      street: map['street'] ?? '',
      isHome: map['isHome'] ?? false,
    );
  }

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
