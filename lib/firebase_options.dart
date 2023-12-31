
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
    apiKey: 'AIzaSyCFZ-_GpRvZdkAcm6vmT4h8-m5exZkPCdk',
    appId: '1:395011371299:web:1d4f4cf559f0110a9b5c96',
    messagingSenderId: '395011371299',
    projectId: 'activitytracker-d9e36',
    authDomain: 'activitytracker-d9e36.firebaseapp.com',
    storageBucket: 'activitytracker-d9e36.appspot.com',
    measurementId: 'G-J94QF7Z1YK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9vDJ7LKz80qxx7qEw25BQRH1PHgCmAtU',
    appId: '1:395011371299:android:bb9c22abd3c375459b5c96',
    messagingSenderId: '395011371299',
    projectId: 'activitytracker-d9e36',
    storageBucket: 'activitytracker-d9e36.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDc1CJYaY3ZQEPHUPY_9iR8i9AKd_oWVwM',
    appId: '1:395011371299:ios:ab20370dc7e4004c9b5c96',
    messagingSenderId: '395011371299',
    projectId: 'activitytracker-d9e36',
    storageBucket: 'activitytracker-d9e36.appspot.com',
    iosBundleId: 'com.example.activityTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDc1CJYaY3ZQEPHUPY_9iR8i9AKd_oWVwM',
    appId: '1:395011371299:ios:b0dc448a5e56dd4b9b5c96',
    messagingSenderId: '395011371299',
    projectId: 'activitytracker-d9e36',
    storageBucket: 'activitytracker-d9e36.appspot.com',
    iosBundleId: 'com.example.activityTracker.RunnerTests',
  );
}
