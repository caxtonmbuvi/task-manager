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
    apiKey: 'AIzaSyBvL6BjlZw0ZsUNu9s2ZsXh9hsyohjUCRI',
    appId: '1:220403672726:web:24d2fbe625752030f244b7',
    messagingSenderId: '220403672726',
    projectId: 'task-manager-39625',
    authDomain: 'task-manager-39625.firebaseapp.com',
    storageBucket: 'task-manager-39625.firebasestorage.app',
    measurementId: 'G-GCNLH5G98V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8chaYcyROJRZq_YLckJQhP5m6y7pBmiA',
    appId: '1:220403672726:android:0f9cfd644cdb792af244b7',
    messagingSenderId: '220403672726',
    projectId: 'task-manager-39625',
    storageBucket: 'task-manager-39625.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLFDpBwSAD4E0GNrFoo-Yw-uJJy3jyTZ8',
    appId: '1:220403672726:ios:b174be8c2d85e721f244b7',
    messagingSenderId: '220403672726',
    projectId: 'task-manager-39625',
    storageBucket: 'task-manager-39625.firebasestorage.app',
    iosBundleId: 'com.example.taskManager',
  );
}
