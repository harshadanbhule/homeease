import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderModel order;
  final UserModel user;

  const OrderDetailsPage({
    Key? key,
    required this.order,
    required this.user,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  LatLng? currentLocation;
  double? distance;
  bool isLoading = true;
  bool isAccepted = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _checkOrderStatus();
  }

  Future<void> _checkOrderStatus() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id)
          .get();
      
      if (doc.exists) {
        setState(() {
          isAccepted = doc.data()?['isAccepted'] ?? false;
        });
      }
    } catch (e) {
      print('Error checking order status: $e');
    }
  }

  Future<void> _acceptOrder() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must be logged in to accept orders")),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id)
          .update({
        'isAccepted': true,
        'acceptedBy': user.uid,
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        isAccepted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order accepted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error accepting order: $e")),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => isLoading = false);
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        if (widget.user.coordinates != null) {
          // Calculate distance between current location and order location
          distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            widget.user.coordinates!.latitude,
            widget.user.coordinates!.longitude,
          );
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Details Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isAccepted)
                          ElevatedButton(
                            onPressed: _acceptOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Text('Accept Order'),
                          ),
                        if (isAccepted)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Accepted',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Service Name: ${widget.order.serviceName}'),
                    Text('Quantity: ${widget.order.quantity}'),
                    Text('Total Amount: ₹${widget.order.totalAmount.toStringAsFixed(2)}'),
                    Text('Order Date: ${widget.order.createdAt}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Customer Details Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Name: ${widget.user.fullName}'),
                    Text('Address: ${widget.user.fullLocation}'),
                    if (widget.user.coordinates != null) ...[
                      SizedBox(height: 16),
                      Text(
                        'Location Coordinates:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Latitude: ${widget.user.coordinates!.latitude}'),
                      Text('Longitude: ${widget.user.coordinates!.longitude}'),
                      if (distance != null) ...[
                        SizedBox(height: 8),
                        Text(
                          'Distance: ${(distance! / 1000).toStringAsFixed(2)} km',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                      SizedBox(height: 16),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : FlutterMap(
                                  options: MapOptions(
                                    center: widget.user.coordinates,
                                    zoom: 12.0,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.example.app',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        // Customer location marker
                                        Marker(
                                          point: widget.user.coordinates!,
                                          width: 40,
                                          height: 40,
                                          child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                                        ),
                                        // Current location marker (if available)
                                        if (currentLocation != null)
                                          Marker(
                                            point: currentLocation!,
                                            width: 40,
                                            height: 40,
                                            child: Icon(Icons.my_location, size: 40, color: Colors.blue),
                                          ),
                                      ],
                                    ),
                                    // Draw a line between current location and customer location
                                    if (currentLocation != null && widget.user.coordinates != null)
                                      PolylineLayer(
                                        polylines: [
                                          Polyline(
                                            points: [currentLocation!, widget.user.coordinates!],
                                            color: Colors.blue,
                                            strokeWidth: 2,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ],
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