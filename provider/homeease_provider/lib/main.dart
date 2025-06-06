import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:homeease_provider/controllers/location_controller.dart';
import 'package:homeease_provider/info/Home.dart';
import 'package:homeease_provider/info/form.dart';
import 'package:homeease_provider/login.dart';
import 'package:homeease_provider/register.dart';
import 'package:homeease_provider/splash.dart';
import 'firebase_options.dart';  
import 'pages/orders_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  Get.put(LocationController()); 
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
          '/home':(context) => Home(),
          '/splash':(context)=> Splash(),
          '/form':(context)=> UserFormPage(),
          '/homedemo':(context)=>OrdersPage()
         // '/home2':(context)=>CustomLoading(),
          //'/shimar':(context)=>ShimarPage()
          //'/location':(context)=> LocationMapPage()



        }
    );
  }
}
