import 'package:flutter/material.dart';
import 'package:homease/info/LocationPermissionPage.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// Replace with your actual import

class UserFormPage extends StatefulWidget {
  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? phoneNumberWithCode;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submitForm() {
  if (_formKey.currentState!.validate() && phoneNumberWithCode != null) {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPermissionPage(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumberWithCode!,
        ),
      ),
    );
  }
}


  void _showPolicyDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.97),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF6216C7)),
                      SizedBox(width: 10),
                      Text(
                        "Homeease Policies",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6216C7),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 1, height: 24),
                  _policyBullet(
                    "Terms of Service",
                    "By using our platform, you agree to appropriate usage, account responsibility, and compliance with laws.",
                  ),
                  _policyBullet(
                    "Payment Terms",
                    "Transactions should occur via authorized channels. Refunds are based on service agreement checks.",
                  ),
                  _policyBullet(
                    "Privacy Policy",
                    "Your data is secured and only used in accordance with our privacy agreement.",
                  ),
                  _policyBullet(
                    "Code of Conduct",
                    "Users must behave respectfully. Any form of harassment, fraud, or abuse leads to suspension.",
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6216C7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text("Got it", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _policyBullet(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 18)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Complete your info",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              Text("First Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your first name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter First Name' : null,
              ),
              SizedBox(height: 16),
              Text("Last Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your last name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter Last Name' : null,
              ),
              SizedBox(height: 16),
              Text("Mobile Number", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              IntlPhoneField(
                decoration: InputDecoration(
                  
                 // labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  
                ),
                initialCountryCode: 'IN',
                 pickerDialogStyle: PickerDialogStyle(
                backgroundColor: Colors.white,
                searchFieldInputDecoration: InputDecoration(
                  hintText: 'Search Country',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                countryNameStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                countryCodeStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                //dividerColor: Colors.grey.shade300,
                padding: EdgeInsets.all(16),
                searchFieldPadding: EdgeInsets.symmetric(horizontal: 16),
                listTilePadding: EdgeInsets.symmetric(vertical: 10),
               // borderRadius: BorderRadius.circular(20),
              ),
                onChanged: (phone) => phoneNumberWithCode = phone.completeNumber,
                validator: (phone) =>
                    phone == null || phone.number.isEmpty ? 'Enter Phone Number' : null,
              ),
              SizedBox(height: 70),
              GestureDetector(
                onTap: _showPolicyDialog,
                child: Container(
                  height: 72,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "By selecting Next, I agree to Homease’s ",
                      style: TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                          text: "terms of service, Payment Terms of Service & Privacy Policy.",
                          style: TextStyle(
                            //decoration: TextDecoration.underline,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 62),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6216C7),
                    minimumSize: Size(width * 0.85, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text("Next", style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
