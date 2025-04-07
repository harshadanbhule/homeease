import 'package:flutter/material.dart';
import 'package:homease/DataBase/user_location_model.dart';
import 'package:homease/info/location_summary.dart';
import 'package:latlong2/latlong.dart';


class LocationDetailsPage extends StatefulWidget {
  final String address;
  final LatLng coordinates;
  final String firstName;
  final String lastName;
  final String phoneNumber; // changed from email

  LocationDetailsPage({
    required this.address,
    required this.coordinates,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber, // changed from email
  });

  @override
  State<LocationDetailsPage> createState() => _LocationDetailsPageState();
}

class _LocationDetailsPageState extends State<LocationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  bool isHome = false;

  void _save() {
    if (_formKey.currentState!.validate()) {
      final userLocation = UserLocationModel(
        firstName: widget.firstName,
        lastName: widget.lastName,
        phoneNumber: widget.phoneNumber, // updated field
        address: widget.address,
        coordinates: widget.coordinates,
        building: buildingController.text,
        apartment: apartmentController.text.isEmpty ? null : apartmentController.text,
        street: streetController.text,
        isHome: isHome,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationSummaryPage(userLocation: userLocation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Confirmed Address:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.address, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: buildingController,
                      decoration: InputDecoration(
                        labelText: "Building *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Building is required" : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: apartmentController,
                      decoration: InputDecoration(
                        labelText: "Apartment/Floor (optional)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: streetController,
                      decoration: InputDecoration(
                        labelText: "Street *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Street is required" : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isHome,
                          onChanged: (val) {
                            setState(() {
                              isHome = val!;
                            });
                          },
                          shape: CircleBorder(),
                        ),
                        Text("Set as Current Home Location")
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _save,
                      icon: Icon(Icons.save),
                      label: Text("Save"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
