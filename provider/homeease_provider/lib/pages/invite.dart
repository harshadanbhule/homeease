//invite.dart


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 650,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/profile/ref.svg',
                height: 200,
              ),
              const SizedBox(height: 32),
              Text(
                'Refer a Friend &\nGet 50% off',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 55),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      "Get 50% off upto \₹ 100 after your friend’s 1st order",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
               Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      "Your friend gets 50% off on their 1st order",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 54),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(100, 27, 180, 1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    
                  },
                  child:  Text(
                    'Refer a friend',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}