import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: user != null
            ? Text(
                "UID: ${user?.uid}",
                style: const TextStyle(fontSize: 18),
              )
            : const Text(
                "User not logged in",
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }
}


