import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:homease/info/location.dart';

class LocationPermissionPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  LocationPermissionPage({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  @override
  _LocationPermissionPageState createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  String _status = "Waiting for permission...";

  void _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _status = "Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng currentPosition = LatLng(position.latitude, position.longitude);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LocationMapPage(
            firstName: widget.firstName,
            lastName: widget.lastName,
            phoneNumber: widget.phoneNumber,
            currentPosition: currentPosition,
          ),
        ),
      );
    } else {
      setState(() => _status = "Permission denied. Enable it from settings.");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
       
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 80, color: Color(0xFF6216C7)),
            SizedBox(height: 24),
            Text(
              "We need your location",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Text(
              "This helps us show better options based on your current location.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _status,
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _checkPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6216C7),
                minimumSize: Size(width * 0.85, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text("Allow Access", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
