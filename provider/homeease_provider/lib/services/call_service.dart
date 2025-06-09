import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

class CallService {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;

  Future<void> initializeCall() async {
    // Request necessary permissions
    await Permission.microphone.request();
    await Permission.camera.request();

    // Configure WebRTC
    final configuration = {
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    };

    // Create peer connection
    peerConnection = await createPeerConnection(configuration);

    // Get local stream
    localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false
    });

    // Add local stream to peer connection
    localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localStream!);
    });

    // Handle incoming stream
    peerConnection!.onTrack = (RTCTrackEvent event) {
      remoteStream = event.streams[0];
    };
  }

  Future<void> startCall(String phoneNumber) async {
    try {
      await initializeCall();

      // Create offer
      RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      // Here you would typically send the offer to your signaling server
      // and handle the answer from the remote peer
      // For now, we'll just log the offer
      print('Call offer created for $phoneNumber');
    } catch (e) {
      print('Error starting call: $e');
    }
  }

  void endCall() {
    localStream?.dispose();
    remoteStream?.dispose();
    peerConnection?.close();
    localStream = null;
    remoteStream = null;
    peerConnection = null;
  }
} 