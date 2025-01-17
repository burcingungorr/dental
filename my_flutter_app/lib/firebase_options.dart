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
    apiKey: 'AIzaSyCYPLLedwIaLUsnSG9_YY7EoE81xb-ThTg',
    appId: '1:480292112961:web:06c530b988aad0887cd4c0',
    messagingSenderId: '480292112961',
    projectId: 'dentai-ba6f2',
    authDomain: 'dentai-ba6f2.firebaseapp.com',
    storageBucket: 'dentai-ba6f2.firebasestorage.app',
    measurementId: 'G-D0GQRBEQF2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2dWyhkMOT2Phpqh83CpRhS4tlV1dOz7g',
    appId: '1:480292112961:android:1d41a3c3be2859647cd4c0',
    messagingSenderId: '480292112961',
    projectId: 'dentai-ba6f2',
    storageBucket: 'dentai-ba6f2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6LKmkdvc9b4BNJ-W-Xq0XPDg5Vez_4a0',
    appId: '1:480292112961:ios:7835adc26efb2ffa7cd4c0',
    messagingSenderId: '480292112961',
    projectId: 'dentai-ba6f2',
    storageBucket: 'dentai-ba6f2.firebasestorage.app',
    iosBundleId: 'com.example.myFlutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6LKmkdvc9b4BNJ-W-Xq0XPDg5Vez_4a0',
    appId: '1:480292112961:ios:7835adc26efb2ffa7cd4c0',
    messagingSenderId: '480292112961',
    projectId: 'dentai-ba6f2',
    storageBucket: 'dentai-ba6f2.firebasestorage.app',
    iosBundleId: 'com.example.myFlutterApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYPLLedwIaLUsnSG9_YY7EoE81xb-ThTg',
    appId: '1:480292112961:web:489620a4712f7d757cd4c0',
    messagingSenderId: '480292112961',
    projectId: 'dentai-ba6f2',
    authDomain: 'dentai-ba6f2.firebaseapp.com',
    storageBucket: 'dentai-ba6f2.firebasestorage.app',
    measurementId: 'G-0WYK5DYX37',
  );
}
