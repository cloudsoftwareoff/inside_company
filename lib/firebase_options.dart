// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAqpZy_VH7EaI6Xngo_WNGh7LVz3Ab4gKw',
    appId: '1:453254468404:web:58f9ff23fcf6767a890b61',
    messagingSenderId: '453254468404',
    projectId: 'inside-company',
    authDomain: 'inside-company.firebaseapp.com',
    databaseURL: 'https://inside-company-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'inside-company.appspot.com',
    measurementId: 'G-3WWMMWZ4FC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXkeAdQg8arCQa8Rv9laIwewCOHf_uvgc',
    appId: '1:453254468404:android:e7786d4d49841b58890b61',
    messagingSenderId: '453254468404',
    projectId: 'inside-company',
    databaseURL: 'https://inside-company-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'inside-company.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBp8Hzh7yNP48c73YTTIdex5wtcLlSI46Y',
    appId: '1:453254468404:ios:815e7c531c3579a0890b61',
    messagingSenderId: '453254468404',
    projectId: 'inside-company',
    databaseURL: 'https://inside-company-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'inside-company.appspot.com',
    iosBundleId: 'com.example.insideCompany',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBp8Hzh7yNP48c73YTTIdex5wtcLlSI46Y',
    appId: '1:453254468404:ios:1271f134f32184e9890b61',
    messagingSenderId: '453254468404',
    projectId: 'inside-company',
    storageBucket: 'inside-company.appspot.com',
    iosBundleId: 'com.example.insideCompany.RunnerTests',
  );
}