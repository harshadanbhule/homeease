import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallService {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;

  Future<void> initializeCall() async {
    try {
      localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': true
      });

      final configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ]
      };

      peerConnection = await createPeerConnection(configuration);

      localStream!.getTracks().forEach((track) {
        peerConnection!.addTrack(track, localStream!);
      });
    } catch (e) {
      print('Error initializing call: $e');
    }
  }

  Future<void> startCall(String phoneNumber) async {
    try {
      // Clean the phone number - just remove "Phone: " prefix
      String cleanNumber = phoneNumber.replaceAll('Phone: ', '').trim();
      
      // Create the tel URI
      final Uri telUri = Uri.parse('tel:$cleanNumber');
      
      // Try to launch the dialer
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        throw 'Could not open phone dialer';
      }
    } catch (e) {
      print('Error in startCall: $e');
      throw 'Could not make call. Please try again.';
    }
  }

  void endCall() {
    localStream?.dispose();
    peerConnection?.close();
  }
} 