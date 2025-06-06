class UserModel {
  final String firstName;
  final String lastName;
  final String address;
  final String building;
  final String? apartment;
  final String street;
  final bool isHome;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.building,
    required this.apartment,
    required this.street,
    required this.isHome,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      address: data['address'] ?? '',
      building: data['building'] ?? '',
      apartment: data['apartment'],
      street: data['street'] ?? '',
      isHome: data['isHome'] ?? false,
    );
  }

  String get fullName => '$firstName $lastName';

  String get fullLocation {
    return "$building${apartment != null ? ', Apt $apartment' : ''}, $street, $address";
  }
}
