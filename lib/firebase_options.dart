// Generated Firebase Options for TrackingMenstructionCycle project
// ⚠️ ACTION REQUIRED: Replace the placeholder values below with your real values from:
//    Firebase Console → Project Settings → Your apps → SDK setup and configuration
//
// OR run in your terminal (after firebase login):
//    flutterfire configure --project=trackingmenstructioncycle

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // REPLACE the placeholder values below with your REAL values!
  // Project ID is confirmed: trackingmenstructioncycle
  // ─────────────────────────────────────────────────────────────────────────

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_WEB_API_KEY',
    authDomain: 'trackingmenstructioncycle.firebaseapp.com',
    projectId: 'trackingmenstructioncycle',
    storageBucket: 'trackingmenstructioncycle.firebasestorage.app',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    appId: 'REPLACE_WITH_WEB_APP_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_ANDROID_API_KEY',
    appId: 'REPLACE_WITH_YOUR_ANDROID_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'trackingmenstructioncycle',
    storageBucket: 'trackingmenstructioncycle.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_IOS_API_KEY',
    appId: 'REPLACE_WITH_YOUR_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'trackingmenstructioncycle',
    storageBucket: 'trackingmenstructioncycle.firebasestorage.app',
    iosClientId: 'REPLACE_WITH_IOS_CLIENT_ID',
    iosBundleId: 'com.bloom.bloomCycle',
  );
}
