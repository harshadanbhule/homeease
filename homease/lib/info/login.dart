import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
  String mail = emailController.text.trim();
  String pass = passwordController.text.trim();

  if (mail.isEmpty || pass.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Enter all the fields")),
    );
  } else {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pass);

      final String uid = userCredential.user!.uid;

      // Check Firestore for location data
      final docSnapshot = await FirebaseFirestore.instance
          .collection('user_locations')
          .doc(uid)
          .get();

      if (docSnapshot.exists) {
        // Data already exists, go to Home page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful. Redirecting to Home.")),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // No data yet, go to form page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful. Please complete your location form.")),
        );
        Navigator.pushReplacementNamed(context, '/form');
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${err.toString()}")),
      );
    }
  }
},

              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
