import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homease/info/location.dart';
import 'package:latlong2/latlong.dart';
 // Make sure this matches your file path



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
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng currentPosition = LatLng(position.latitude, position.longitude);

      // Navigate to map page
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
    return Scaffold(
      appBar: AppBar(title: Text("Location Access")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 60, color: Colors.purple),
            SizedBox(height: 20),
            Text("We need access to your location", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(_status, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _checkPermission,
              child: Text("Allow Access"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6216C7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
