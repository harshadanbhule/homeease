import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeease_provider/controllers/UserLocationController.dart';
import 'package:homeease_provider/pages/shimar.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:homeease_provider/DataBase/user_location_model.dart';

class LocationDetailsPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String education;
  final List<String> languageList;
  final String serviceName;
  final String workLocation;
  final LatLng currentPosition;
  final String address;
  final LatLng coordinates;

  const LocationDetailsPage({
    Key? key,
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
  }) : super(key: key);

  @override
  State<LocationDetailsPage> createState() => _LocationDetailsPageState();
}

class _LocationDetailsPageState extends State<LocationDetailsPage> {
  final userData = Get.find<UserLocationController>().data;
  final _formKey = GlobalKey<FormState>();
  final _buildingController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _floorController = TextEditingController();
  final _streetController = TextEditingController();
  bool _setAsHome = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    try {
      final userLocation = UserLocationModel(
        firstName: widget.firstName,
        lastName: widget.lastName,
        phoneNumber: widget.phoneNumber,
        education: widget.education,
        languageList: widget.languageList,
        serviceName: widget.serviceName,
        workLocation: widget.workLocation,
        currentPosition: widget.currentPosition,
        coordinates: widget.coordinates,
        address: widget.address,
        building: _buildingController.text,
        apartment:
            _apartmentController.text.isEmpty ? null : _apartmentController.text,
        floor: _floorController.text.isEmpty ? null : _floorController.text,
        street: _streetController.text,
        isHome: _setAsHome,
      );

     await FirebaseFirestore.instance
    .collection('worker_locations') 
    .doc(user.uid)
    .set(userLocation.toMap());

     Get.find<UserLocationController>().setUserLocation(userLocation);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location saved to Firestore!")));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ShimarPage()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to save: $e")));
    }
  }

  @override
  void dispose() {
    _buildingController.dispose();
    _apartmentController.dispose();
    _floorController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 10),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Text(
              "Confirm your home address",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),
            Text(
              "Additional information",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.address,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    center: widget.coordinates,
                    zoom: 16.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: widget.coordinates,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_pin,
                              size: 40, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _buildingController,
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: 'Building',
                    style: GoogleFonts.poppins(color: Colors.black),
                    children: const [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Building is required" : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _apartmentController,
                    decoration: InputDecoration(
                      labelText: "Apartment",
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _floorController,
                    decoration: InputDecoration(
                      labelText: "Floor",
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _streetController,
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: 'Street',
                    style: GoogleFonts.poppins(color: Colors.black),
                    children: const [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Street is required" : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _setAsHome,
                  onChanged: (val) {
                    setState(() {
                      _setAsHome = val ?? false;
                    });
                  },
                ),
                Text(
                  "Set as current home address",
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23334A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Save Changes",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
