// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCmi2pvDf9mnldVjovs8qEF1Oknx41dPeA',
    appId: '1:1016784946205:web:ebdb9ffda1beb60797b2f4',
    messagingSenderId: '1016784946205',
    projectId: 'homeease-3c6b3',
    authDomain: 'homeease-3c6b3.firebaseapp.com',
    storageBucket: 'homeease-3c6b3.firebasestorage.app',
    measurementId: 'G-JK73LPT5HH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBewKMYyLzroAUtbEQGib0S7obxLaUubsk',
    appId: '1:1016784946205:android:035e26bba91fc94e97b2f4',
    messagingSenderId: '1016784946205',
    projectId: 'homeease-3c6b3',
    storageBucket: 'homeease-3c6b3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrdubKwt_fv0AuqxX0GvSTUp70zdr1XhI',
    appId: '1:1016784946205:ios:bf48a76748de8c3297b2f4',
    messagingSenderId: '1016784946205',
    projectId: 'homeease-3c6b3',
    storageBucket: 'homeease-3c6b3.firebasestorage.app',
    iosBundleId: 'com.example.homease',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBrdubKwt_fv0AuqxX0GvSTUp70zdr1XhI',
    appId: '1:1016784946205:ios:bf48a76748de8c3297b2f4',
    messagingSenderId: '1016784946205',
    projectId: 'homeease-3c6b3',
    storageBucket: 'homeease-3c6b3.firebasestorage.app',
    iosBundleId: 'com.example.homease',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCmi2pvDf9mnldVjovs8qEF1Oknx41dPeA',
    appId: '1:1016784946205:web:279145b8e48b31d097b2f4',
    messagingSenderId: '1016784946205',
    projectId: 'homeease-3c6b3',
    authDomain: 'homeease-3c6b3.firebaseapp.com',
    storageBucket: 'homeease-3c6b3.firebasestorage.app',
    measurementId: 'G-5T1EF8QLC1',
  );
}
