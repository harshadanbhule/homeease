import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../services/call_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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
  bool isCallActive = false;
  final CallService _callService = CallService();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _checkOrderStatus();
    _initRenderers();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _callService.endCall();
    super.dispose();
  }

  Future<void> _startCall() async {
    try {
      await _callService.startCall(widget.user.phoneNumber);
      setState(() {
        isCallActive = true;
      });
      _showCallInterface();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start call: $e')),
      );
    }
  }

  void _endCall() {
    _callService.endCall();
    setState(() {
      isCallActive = false;
    });
    Navigator.pop(context); // Close call interface
  }

  void _showCallInterface() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Call in Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.call_end, color: Colors.white),
                    onPressed: _endCall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    RTCVideoView(_remoteRenderer),
                    Positioned(
                      right: 20,
                      top: 20,
                      child: Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: RTCVideoView(_localRenderer, mirror: true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.white),
                    onPressed: () {
                      // Toggle microphone
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.call_end, color: Colors.white),
                    onPressed: _endCall,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.white),
                    onPressed: () {
                      // Toggle speaker
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkOrderStatus() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('orders_acceptedmain')
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
          const SnackBar(
            content: Text("You must be logged in to accept orders"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // First check if the order is still available
      final orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id)
          .get();

      if (!orderDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This order no longer exists"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (orderDoc.data()?['isAccepted'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This order has already been accepted by another provider"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get current timestamp
      final now = FieldValue.serverTimestamp();

      // Create a batch write to ensure atomic operations
      final batch = FirebaseFirestore.instance.batch();

      // Update the original order
      final orderRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id);
      
      batch.update(orderRef, {
        'isAccepted': true,
        'acceptedBy': user.uid,
        'acceptedAt': now,
        'status': 'accepted',
        'providerDetails': {
          'providerId': user.uid,
          'acceptedAt': now,
          'serviceName': widget.order.serviceName,
          'orderId': widget.order.id,
        }
      });

      // Create accepted order document in orders_acceptedmain collection
      final acceptedOrderRef = FirebaseFirestore.instance
          .collection('orders_acceptedmain')
          .doc(widget.order.id);
      
      batch.set(acceptedOrderRef, {
        'orderId': widget.order.id,
        'providerId': user.uid,
        'workerId': user.uid, // Adding workerId to match the stricter rule
        'customerId': widget.order.userId,
        'serviceName': widget.order.serviceName,
        'quantity': widget.order.quantity,
        'totalAmount': widget.order.totalAmount,
        'acceptedAt': now,
        'status': 'in_progress',
        'customerDetails': {
          'name': widget.user.fullName,
          'phoneNumber': widget.user.phoneNumber,
          'address': widget.user.fullLocation,
          'coordinates': widget.user.coordinates != null ? {
            'latitude': widget.user.coordinates!.latitude,
            'longitude': widget.user.coordinates!.longitude,
          } : null,
        },
        'orderDetails': {
          'createdAt': widget.order.createdAt,
          'serviceImage': widget.order.serviceImage,
        }
      });

      // Also create a document in accepted_orders collection for the worker
      final workerAcceptedOrderRef = FirebaseFirestore.instance
          .collection('accepted_orders')
          .doc(user.uid)
          .collection('orders')
          .doc(widget.order.id);

      batch.set(workerAcceptedOrderRef, {
        'orderId': widget.order.id,
        'status': 'in_progress',
        'acceptedAt': now,
        'serviceName': widget.order.serviceName,
      });

      // Commit the batch
      await batch.commit();

      setState(() {
        isAccepted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order accepted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error accepting order: $e');
      String errorMessage = "Error accepting order";
      
      if (e.toString().contains('permission-denied')) {
        errorMessage = "You don't have permission to accept this order. Please check your account status.";
      } else if (e.toString().contains('not-found')) {
        errorMessage = "Order not found. It may have been removed.";
      } else if (e.toString().contains('already-exists')) {
        errorMessage = "This order has already been accepted.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
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
        backgroundColor: const Color.fromRGBO(100, 27, 180, 1),
        title: Text('Order Details',style: TextStyle(
          color: Colors.white
        ),),
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
                              backgroundColor: const Color.fromRGBO(100, 27, 180, 1),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Text('Accept Order',style: TextStyle(color: Colors.white),),
                          )
                        else
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isAccepted)
                          ElevatedButton.icon(
                            onPressed: _startCall,
                            icon: Icon(Icons.call, color: Colors.white),
                            label: Text('Call Customer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Name: ${widget.user.fullName}'),
                    if (isAccepted) ...[
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.phone, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Phone: ${widget.user.phoneNumber}",
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 16),
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