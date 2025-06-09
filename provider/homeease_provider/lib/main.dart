import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:homeease_provider/Pages/homepage.dart';
import 'package:homeease_provider/controllers/UserLocationController.dart';
import 'package:homeease_provider/controllers/UserProfileController.dart';
import 'package:homeease_provider/controllers/location_controller.dart';
import 'package:homeease_provider/controllers/userDetail_controller.dart';
import 'package:homeease_provider/info/form.dart';
import 'package:homeease_provider/login.dart';
import 'package:homeease_provider/pages/shimar.dart';
import 'package:homeease_provider/register.dart';
import 'package:homeease_provider/splash.dart';
import 'firebase_options.dart';  
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
   Get.put(UserLocationController());
  Get.put(LocationController()); 
  Get.put(UserDetailController());
  Get.put(UserProfileController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Auth UI',
        initialRoute: '/splash',
        routes: {
        '/login': (context) => Login(),
          '/register': (context) =>  Register(),
         // '/home':(context) => Homepage(),
          '/splash':(context)=> Splash(),
          '/form':(context)=> UserFormPage(),
          '/homedemo':(context)=>Homepage(),
         // '/home2':(context)=>CustomLoading(),
          '/shimar':(context)=>ShimarPage(),
          //'/orderpage':(context)=> OrdersPage()



        }
    );
  }
}
