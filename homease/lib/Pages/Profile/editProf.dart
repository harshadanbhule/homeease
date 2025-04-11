import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/login.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool isLoading = true;
  bool editFirstName = false;
  bool editLastName = false;
  bool editPhone = false;
  bool editEmail = false;

  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('user_locations')
            .doc(user!.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      firstName = data['firstName'] ?? '';
      lastName = data['lastName'] ?? '';
      phone = data['phoneNumber'] ?? '';
      email = user!.email ?? '';

      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _phoneController.text = phone;
      _emailController.text = email;
    }

    setState(() => isLoading = false);
  }

  Future<void> _updateProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('user_locations')
          .doc(user!.uid)
          .update({
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'phoneNumber': _phoneController.text.trim(),
          });

      setState(() {
        firstName = _firstNameController.text;
        lastName = _lastNameController.text;
        phone = _phoneController.text;
        editFirstName = false;
        editLastName = false;
        editPhone = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile updated")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    }
  }

  Future<void> _deleteAccount() async {
    try {
      await user!.delete();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Account deletion failed: $e")));
    }
  }

  Widget _buildField({
    required String label,
    required Widget child,
    required VoidCallback onEdit,
    bool isEditing = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        child: Row(
          children: [
            Expanded(child: child),
            const SizedBox(width: 8),
            Container(
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black54, width: 1.5),
              ),
              child: TextButton(
                onPressed: onEdit,
                child: Text(
                  textAlign: TextAlign.center,
                  isEditing ? 'Save' : 'Edit',
                  selectionColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit account info'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'First Name',
                            isEditing: editFirstName,
                            onEdit: () {
                              setState(() {
                                if (editFirstName) _updateProfile();
                                editFirstName = !editFirstName;
                              });
                            },
                            child:
                                editFirstName
                                    ? TextField(
                                      controller: _firstNameController,
                                    )
                                    : ListTile(
                                      title: Text(firstName),
                                      subtitle: const Text("First Name"),
                                    ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            label: 'Last Name',
                            isEditing: editLastName,
                            onEdit: () {
                              setState(() {
                                if (editLastName) _updateProfile();
                                editLastName = !editLastName;
                              });
                            },
                            child:
                                editLastName
                                    ? TextField(controller: _lastNameController)
                                    : ListTile(
                                      title: Text(lastName),
                                      subtitle: const Text("Last Name"),
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1, color: Colors.black26),
                    _buildField(
                      label: "Phone Number",
                      isEditing: editPhone,
                      onEdit: () {
                        setState(() {
                          if (editPhone) _updateProfile();
                          editPhone = !editPhone;
                        });
                      },
                      child:
                          editPhone
                              ? IntlPhoneField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(),
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {},
                              )
                              : ListTile(
                                title: Text(phone),
                                subtitle: const Text("Phone Number"),
                              ),
                    ),
                    Divider(thickness: 1, color: Colors.black26),
                    _buildField(
                      label: "Email",
                      isEditing: false,
                      onEdit: () {
                        // Email update logic goes here if needed
                      },
                      child: ListTile(
                        title: Text(email),
                        subtitle: const Text("Email"),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text("Change Password"),
                      subtitle: const Text(
                        "Looking to change your current password?",
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          // Navigate to password change page
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          height: 35,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black54, width: 1.5),
                          ),
                          child: const Text("Change"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100,),
                    
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Logout",
                        style: GoogleFonts.inter(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _deleteAccount,
                      child: Text(
                        "Delete your account",
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 15,color:Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
