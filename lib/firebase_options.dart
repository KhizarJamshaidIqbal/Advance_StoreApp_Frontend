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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA7mEPQeC0qKhYgU6ZTX4DnRgVa742JcYc',
    appId: '1:454052655606:web:1f72cfaf10ee210f1c97d7',
    messagingSenderId: '454052655606',
    projectId: 'dfile-99af8',
    authDomain: 'dfile-99af8.firebaseapp.com',
    databaseURL: 'https://dfile-99af8-default-rtdb.firebaseio.com',
    storageBucket: 'dfile-99af8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC67KwoqHFwxuEx33719uT17-jQnBFBflU',
    appId: '1:454052655606:android:b7fe4f977ae82cce1c97d7',
    messagingSenderId: '454052655606',
    projectId: 'dfile-99af8',
    databaseURL: 'https://dfile-99af8-default-rtdb.firebaseio.com',
    storageBucket: 'dfile-99af8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYrDJWmpnOP4ou_1m7YeN_Hk7h0DM8SGo',
    appId: '1:454052655606:ios:7bcdd2c7f25868ca1c97d7',
    messagingSenderId: '454052655606',
    projectId: 'dfile-99af8',
    storageBucket: 'dfile-99af8.appspot.com',
    iosBundleId: 'com.example.fyp7th',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA7mEPQeC0qKhYgU6ZTX4DnRgVa742JcYc',
    appId: '1:454052655606:web:1f72cfaf10ee210f1c97d7',
    messagingSenderId: '454052655606',
    projectId: 'dfile-99af8',
    authDomain: 'dfile-99af8.firebaseapp.com',
    storageBucket: 'dfile-99af8.appspot.com',
  );
}