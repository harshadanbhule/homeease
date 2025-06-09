import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class ProviderOrderDetail extends StatefulWidget {
  final String customerName;
  final String customerPhone;
  final String orderId;
  final String customerId;
  final String serviceName;
  final int quantity;
  final double totalAmount;
  final String status;

  const ProviderOrderDetail({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.orderId,
    required this.customerId,
    required this.serviceName,
    required this.quantity,
    required this.totalAmount,
    required this.status,
  });

  @override
  State<ProviderOrderDetail> createState() => _ProviderOrderDetailState();
}

class _ProviderOrderDetailState extends State<ProviderOrderDetail> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool _isCallActive = false;
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  String? roomId;

  @override
  void initState() {
    super.initState();
    _initWebRTC();
  }

  Future<void> _initWebRTC() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    
    roomId = 'room_${widget.orderId}';
    
    // Listen for incoming calls
    FirebaseFirestore.instance
        .collection('webrtc_rooms')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['offer'] != null) {
          _handleOffer(data['offer']);
        }
      }
    });
  }

  Future<void> _startCall() async {
    try {
      localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': true
      });
      
      _localRenderer.srcObject = localStream;

      final configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ]
      };

      peerConnection = await createPeerConnection(configuration);

      localStream!.getTracks().forEach((track) {
        peerConnection!.addTrack(track, localStream!);
      });

      peerConnection!.onIceCandidate = (candidate) {
        if (candidate != null) {
          FirebaseFirestore.instance
              .collection('webrtc_rooms')
              .doc(roomId)
              .collection('candidates')
              .add(candidate.toMap());
        }
      };

      final offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      await FirebaseFirestore.instance
          .collection('webrtc_rooms')
          .doc(roomId)
          .set({
        'offer': offer.toMap(),
        'providerId': FirebaseAuth.instance.currentUser?.uid ?? '',
        'customerId': widget.customerId,
        'orderId': widget.orderId,
      });

      setState(() {
        _isCallActive = true;
      });
    } catch (e) {
      print('Error starting call: $e');
    }
  }

  Future<void> _handleOffer(Map<String, dynamic> offer) async {
    try {
      await peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );

      final answer = await peerConnection!.createAnswer();
      await peerConnection!.setLocalDescription(answer);

      await FirebaseFirestore.instance
          .collection('webrtc_rooms')
          .doc(roomId)
          .update({
        'answer': answer.toMap(),
      });
    } catch (e) {
      print('Error handling offer: $e');
    }
  }

  Future<void> _endCall() async {
    try {
      await localStream?.dispose();
      await peerConnection?.close();
      await _localRenderer.dispose();
      await _remoteRenderer.dispose();
      
      await FirebaseFirestore.instance
          .collection('webrtc_rooms')
          .doc(roomId)
          .delete();

      setState(() {
        _isCallActive = false;
      });
    } catch (e) {
      print('Error ending call: $e');
    }
  }

  Future<void> _makePhoneCall() async {
    // Request phone permission on Android
    if (await Permission.phone.request().isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: widget.customerPhone);
      try {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch phone dialer'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error making phone call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone permission is required to make calls'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Details Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Details',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Service', widget.serviceName),
                  _buildDetailRow('Quantity', widget.quantity.toString()),
                  _buildDetailRow('Total Amount', '₹${widget.totalAmount}'),
                  _buildDetailRow('Status', widget.status),
                ],
              ),
            ),

            // Customer Details Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Details',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Name', widget.customerName),
                  _buildDetailRow('Phone', widget.customerPhone),
                ],
              ),
            ),

            // Video Call View
            if (_isCallActive)
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: RTCVideoView(
                        _localRenderer,
                        mirror: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RTCVideoView(
                        _remoteRenderer,
                        mirror: true,
                      ),
                    ),
                  ],
                ),
              ),

            // Call Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _makePhoneCall,
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: Text(
                        'Call',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isCallActive ? _endCall : _startCall,
                      icon: Icon(
                        _isCallActive ? Icons.call_end : Icons.video_call,
                        color: Colors.white,
                      ),
                      label: Text(
                        _isCallActive ? 'End Call' : 'Video Call',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCallActive ? Colors.red : Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 