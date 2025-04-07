import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:homease/info/locationdetail.dart';
import 'package:latlong2/latlong.dart';

class LocationMapPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final LatLng currentPosition;

  LocationMapPage({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.currentPosition,
  });

  @override
  _LocationMapPageState createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  LatLng? _currentPosition;
  String _address = "Fetching address...";

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.currentPosition;
    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _address =
            "${place.name}, ${place.street}, ${place.locality}";
      });
    } catch (e) {
      setState(() {
        _address = "Unable to get address.";
      });
    }
  }

  void _confirmLocation() {
    if (_currentPosition != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationDetailsPage(
            address: _address,
            coordinates: _currentPosition!,
            firstName: widget.firstName,
            lastName: widget.lastName,
            phoneNumber: widget.phoneNumber,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _currentPosition!,
                    initialZoom: 17.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentPosition!,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.purple,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // App bar
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                     
                    ],
                  ),
                ),

                // Address card
                Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.black54),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _address,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Lagos, Nigeria",
                                  style: TextStyle(color: Colors.grey[700]),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // Confirm button
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(35, 51, 74, 1),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Confirm location",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
