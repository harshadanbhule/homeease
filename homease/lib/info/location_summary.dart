import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homease/DataBase/user_location_model.dart';
import 'package:homease/info/Home.dart';


class LocationSummaryPage extends StatelessWidget {
  final UserLocationModel userLocation;

  LocationSummaryPage({required this.userLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Name: ${userLocation.firstName} ${userLocation.lastName}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Phone Number: ${userLocation.phoneNumber}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Address: ${userLocation.address}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Coordinates: ${userLocation.coordinates.latitude}, ${userLocation.coordinates.longitude}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Building: ${userLocation.building}",
              style: TextStyle(fontSize: 16),
            ),
            if (userLocation.apartment != null &&
                userLocation.apartment!.isNotEmpty)
              Text(
                "Apartment/Floor: ${userLocation.apartment}",
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),
            Text(
              "Street: ${userLocation.street}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Is Home Location: ${userLocation.isHome ? 'Yes' : 'No'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
  onPressed: () async {
    await _saveToFirestore(context, userLocation);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()),
      (route) => false,
    );
  },
  child: Text("Finish"),
  style: ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, 50),
    textStyle: TextStyle(fontSize: 18),
  ),
),

          ],
        ),
      ),
    );
  }

  Future<void> _saveToFirestore(
      BuildContext context, UserLocationModel userLocation) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      final locationData = {
        'firstName': userLocation.firstName,
        'lastName': userLocation.lastName,
        'phoneNumber': userLocation.phoneNumber,
        'address': userLocation.address,
        'coordinates': {
          'latitude': userLocation.coordinates.latitude,
          'longitude': userLocation.coordinates.longitude,
        },
        'building': userLocation.building,
        'apartment': userLocation.apartment,
        'street': userLocation.street,
        'isHome': userLocation.isHome,
      };

      try {
        await FirebaseFirestore.instance
            .collection('user_locations')
            .doc(uid)
            .set(locationData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location saved to Firestore!")),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save location: $error")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
    }
  }
}
