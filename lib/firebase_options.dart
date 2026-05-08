// ============================================================
// TODO: Run `flutterfire configure` to auto-generate this file.
//
// Steps:
//   1. Create a Firebase project at https://console.firebase.google.com
//   2. Install FlutterFire CLI:
//        dart pub global activate flutterfire_cli
//   3. Run from the project root:
//        flutterfire configure
//   4. This file will be overwritten with your real Firebase config.
//   5. Also place google-services.json  → android/app/
//              GoogleService-Info.plist → ios/Runner/
// ============================================================

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web platform is not configured. Run flutterfire configure.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Unsupported platform. Run flutterfire configure.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPQJl5tEYZSvEcY8l7-kRwdQdeUwplqr4',
    appId: '1:689711972244:android:be81e54671888e0d0d5981',
    messagingSenderId: '689711972244',
    projectId: 'sip-sales-b5656',
    storageBucket: 'sip-sales-b5656.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeQ_cKyHu79U-U4Y61nslla47bIa0-j3s',
    appId: '1:689711972244:ios:b9af68864b3b2fae0d5981',
    messagingSenderId: '689711972244',
    projectId: 'sip-sales-b5656',
    storageBucket: 'sip-sales-b5656.firebasestorage.app',
    iosBundleId: 'com.stsj.sipsales',
  );
}
