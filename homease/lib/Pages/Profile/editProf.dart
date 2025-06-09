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
              color: Colors.deepPurple,
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
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // -- First & Last Name Fields --
                    Row(
                      children: [
                        Expanded(
                          child: _buildEditableCard(
                            title: 'First Name',
                            value: firstName,
                            isEditing: editFirstName,
                            controller: _firstNameController,
                            onToggle: () {
                              setState(() {
                                if (editFirstName) _updateProfile();
                                editFirstName = !editFirstName;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildEditableCard(
                            title: 'Last Name',
                            value: lastName,
                            isEditing: editLastName,
                            controller: _lastNameController,
                            onToggle: () {
                              setState(() {
                                if (editLastName) _updateProfile();
                                editLastName = !editLastName;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // -- Phone Number --
                    _buildEditableCard(
                      title: 'Phone Number',
                      value: phone,
                      isEditing: editPhone,
                      controller: _phoneController,
                      onToggle: () {
                        setState(() {
                          if (editPhone) _updateProfile();
                          editPhone = !editPhone;
                        });
                      },
                      isPhone: true,
                    ),

                    // -- Email (non-editable) --
                    _buildEditableCard(
                      title: 'Email',
                      value: email,
                      isEditing: editEmail,
                      controller: _emailController,
                      onToggle: () {
                        setState(() {
                          if (editEmail) {
                            email = _emailController.text.trim();
                            // You can add FirebaseAuth updateEmail logic here if needed
                          }
                          editEmail = !editEmail;
                        });
                      },
                    ),

                    // -- Change Password --
                    _buildActionCard(
                      title: "Change Password",
                      subtitle: "Want to change your current password?",
                      buttonText: "Change",
                      onPressed: () {
                        // Navigate to password change screen
                      },
                    ),

                    const SizedBox(height: 32),

                    // -- Logout & Delete Account --
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Login()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.sizeOf(context).width - 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromARGB(255, 245, 245, 245),
                          border: Border.all(
                            color: const Color.fromRGBO(100, 27, 180, 1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: GoogleFonts.inter(
                            color: const Color.fromRGBO(100, 27, 180, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _deleteAccount,
                      child: const Text(
                        "Delete your account",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildEditableCard({
    required String title,
    required String value,
    required bool isEditing,
    required TextEditingController controller,
    required VoidCallback onToggle,
    bool isPhone = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            isEditing
                ? isPhone
                    ? IntlPhoneField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      initialCountryCode: 'IN',
                    )
                    : TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    )
                : Text(value, style: GoogleFonts.inter(fontSize: 16)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onToggle,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(isEditing ? 'Save' : 'Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticCard({required String title, required String value}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, style: GoogleFonts.inter(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: OutlinedButton(onPressed: onPressed, child: Text(buttonText)),
      ),
    );
  }
}
