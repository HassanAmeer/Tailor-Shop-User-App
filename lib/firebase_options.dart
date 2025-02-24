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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAikLQYyAyn1CgRrx_lWwA9Og351XEt89w',
    appId: '1:102183749136:android:32a5d46e0f9ef9cf7f2c95',
    messagingSenderId: '102183749136',
    projectId: 'tailorshop-786',
    databaseURL: 'https://tailorshop-786-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tailorshop-786.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsBgJ89Jvr_cLB-GPjzqhneS_r_ViUTmM',
    appId: '1:102183749136:ios:f56da7739c2f5eeb7f2c95',
    messagingSenderId: '102183749136',
    projectId: 'tailorshop-786',
    databaseURL: 'https://tailorshop-786-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tailorshop-786.firebasestorage.app',
    iosBundleId: 'com.three.starworld',
  );

}