import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Editadd extends StatefulWidget {
  const Editadd({super.key});

  @override
  State<Editadd> createState() => _EditaddState();
}

class _EditaddState extends State<Editadd> {
  bool isLoading = true;
  bool isEditing = false;

  String building = '';
  String apartment = '';
  String street = '';
  String city = '';

  final _buildingController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('user_locations')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          building = data['building'] ?? '';
          apartment = data['apartment'] ?? '';
          street = data['street'] ?? '';
          city = data['city'] ?? '';

          _buildingController.text = building;
          _apartmentController.text = apartment;
          _streetController.text = street;
          _cityController.text = city;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _updateAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user_locations')
          .doc(user.uid)
          .update({
            'building': _buildingController.text.trim(),
            'apartment': _apartmentController.text.trim(),
            'street': _streetController.text.trim(),
            'city': _cityController.text.trim(),
          });

      setState(() {
        building = _buildingController.text.trim();
        apartment = _apartmentController.text.trim();
        street = _streetController.text.trim();
        city = _cityController.text.trim();
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address updated successfully')),
      );
    }
  }

  Widget _buildAddressCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            isEditing
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Building', _buildingController),
                    const SizedBox(height: 30),
                    _buildTextField('Apartment', _apartmentController),
                    const SizedBox(height: 30),
                    _buildTextField('Street', _streetController),
                    const SizedBox(height: 30),
                    _buildTextField('City', _cityController),
                    const SizedBox(height: 45),
                    GestureDetector(
                      onTap: _updateAddress,
                      child: Container(
                        alignment: Alignment.center,
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color.fromRGBO(100, 27, 180, 1),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(CupertinoIcons.home, color: Colors.deepPurple),
                        SizedBox(width: 10),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$building${apartment.isNotEmpty ? ', $apartment' : ''}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(street, style: const TextStyle(fontSize: 15)),
                    Text(city, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() => isEditing = true),
                      child: const Text(
                        "Edit Address",
                        style: TextStyle(
                          color: Color.fromRGBO(100, 27, 180, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,

        labelStyle: GoogleFonts.poppins(
          fontSize: 18,

          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(child: _buildAddressCard()),
    );
  }
}
