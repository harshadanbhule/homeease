import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homease/Getx%20Controller/favorite_controller.dart';
import 'package:homease/Getx%20Controller/service_controller.dart';
import 'package:homease/Pages/shimar.dart';
import 'package:homease/controllers/location_controller.dart';

import 'package:homease/Pages/homepage.dart';
import 'package:homease/info/Home.dart';

import 'package:homease/info/form.dart';

import 'package:homease/login.dart';
import 'package:homease/register.dart';
import 'package:homease/splash.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBewKMYyLzroAUtbEQGib0S7obxLaUubsk", 
        appId: "1:1016784946205:android:035e26bba91fc94e97b2f4",
        messagingSenderId: "1016784946205",
        projectId: "homeease-3c6b3",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  
  Get.put(LocationController()); 
  Get.put(ServiceController());
  Get.put(FavoriteController());
 
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       debugShowCheckedModeBanner: false,
        title: 'Flutter Auth UI',
        initialRoute: '/splash',
        routes: {
        '/login': (context) => Login(),
          '/register': (context) =>  Register(),
          '/home':(context) => Home(),
          '/splash':(context)=> Splash(),
          '/form':(context)=> UserFormPage(),
          '/home2':(context)=>CustomLoading(),
          '/shimar':(context)=>ShimarPage()
          //'/location':(context)=> LocationMapPage()



        }
    );
  }
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  // Register the LocationController globally
  Get.put(LocationController());
Get.put(ServiceController());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Homease',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CustomLoading(), // Change this to your starting page
    );
  }
}*/
