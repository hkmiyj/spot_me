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
    apiKey: 'AIzaSyD_qIKV1tgjT8NOoGjcdvzWC-m9nTSeqqk',
    appId: '1:232282360593:web:f4686310deda36f35f1ab0',
    messagingSenderId: '232282360593',
    projectId: 'spotme-0001',
    authDomain: 'spotme-0001.firebaseapp.com',
    storageBucket: 'spotme-0001.appspot.com',
    measurementId: 'G-YR4PVXHVHS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUmreXAIVSFRaguTgXZeb7oBT7J9K6EqE',
    appId: '1:232282360593:android:c8bbb0f16c37d3965f1ab0',
    messagingSenderId: '232282360593',
    projectId: 'spotme-0001',
    storageBucket: 'spotme-0001.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOlvRgeYnBWolU0MoiJTM7X87mMFYQOYs',
    appId: '1:232282360593:ios:24ac8e9ea1e2d2ee5f1ab0',
    messagingSenderId: '232282360593',
    projectId: 'spotme-0001',
    storageBucket: 'spotme-0001.appspot.com',
    iosClientId: '232282360593-pitib6u1dap6bmdta6gpls70qua0icu9.apps.googleusercontent.com',
    iosBundleId: 'com.mydomain.spotMe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDOlvRgeYnBWolU0MoiJTM7X87mMFYQOYs',
    appId: '1:232282360593:ios:24ac8e9ea1e2d2ee5f1ab0',
    messagingSenderId: '232282360593',
    projectId: 'spotme-0001',
    storageBucket: 'spotme-0001.appspot.com',
    iosClientId: '232282360593-pitib6u1dap6bmdta6gpls70qua0icu9.apps.googleusercontent.com',
    iosBundleId: 'com.mydomain.spotMe',
  );
}
