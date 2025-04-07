import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homease/info/location.dart';
import 'package:latlong2/latlong.dart';

class LocationPerm extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const LocationPerm({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  @override
  State<LocationPerm> createState() => _LocationPermState();
}

class _LocationPermState extends State<LocationPerm> {
  String _status = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

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
        desiredAccuracy: LocationAccuracy.high,
      );

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/splash/image 2 (1).png"),
              Image.asset("assets/splash/IMG_0157 1.png"),
            ],
          ),
          SvgPicture.asset('assets/onboarding/Address-amico 1.svg', height: 200),
          Text(
            "Allow location access?",
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(27, 36, 49, 1),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.sizeOf(context).width - 75,
            child: Text(
              "We need your location access to easily find Skillr professionals around you.",
              textAlign: TextAlign.center,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Color.fromRGBO(119, 119, 119, 1),
              ),
            ),
          ),
          GestureDetector(
            onTap: _checkPermission,
            child: Container(
              height: 50,
              width: MediaQuery.sizeOf(context).width - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(35, 51, 74, 1),
              ),
              child: Center(
                child: Text(
                  "Allow location access",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          if (_status.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _status,
                style: TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          Text(
            "Skip this step",
            style: GoogleFonts.bricolageGrotesque(
              decoration: TextDecoration.underline,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(49, 49, 49, 1),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/splash/image 3.png"),
              Image.asset("assets/onboarding/image 4.png"),
            ],
          )
        ],
      ),
    );
  }
}
