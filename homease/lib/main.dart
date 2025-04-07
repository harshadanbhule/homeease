import 'package:flutter/material.dart';
import 'package:homease/firebase_options.dart';
import 'package:homease/info/Home.dart';

import 'package:homease/info/form.dart';

import 'package:homease/login.dart';
import 'package:homease/register.dart';
import 'package:homease/splash.dart';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  QuerySnapshot snapshot=await  FirebaseFirestore.instance.collection("users").get();
  for(var doc in snapshot.docs){
  log(doc.data().toString());
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
        title: 'Flutter Auth UI',
        initialRoute: '/splash',
        routes: {
        '/login': (context) => Login(),
          '/register': (context) =>  Register(),
          '/home':(context) => Home(),
          '/splash':(context)=> Splash(),
          '/form':(context)=> UserFormPage(),
          //'/location':(context)=> LocationMapPage()



        }
    );
  }
}
