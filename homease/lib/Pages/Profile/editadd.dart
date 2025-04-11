import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      final doc = await FirebaseFirestore.instance
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isEditing
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Building', _buildingController),
                  const SizedBox(height: 8),
                  _buildTextField('Apartment', _apartmentController),
                  const SizedBox(height: 8),
                  _buildTextField('Street', _streetController),
                  const SizedBox(height: 8),
                  _buildTextField('City', _cityController),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _updateAddress,
                    child: const Text('Save'),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.home_outlined),
                      SizedBox(width: 8),
                      Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('$building ${apartment.isNotEmpty ? ", $apartment" : ""}'),
                  Text(street),
                  Text(city),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => setState(() => isEditing = true),
                    child: const Text(
                      "Edit Address",
                      style: TextStyle(color: Colors.purple),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        leading: const BackButton(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(child: _buildAddressCard()),
    );
  }
}
