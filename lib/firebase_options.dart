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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAxAEDBwJF44vaulGadwEAi5YcW9jBua_Q",
    authDomain: "workout-organiser-6bebb.firebaseapp.com",
    projectId: "workout-organiser-6bebb",
    storageBucket: "workout-organiser-6bebb.appspot.com",
    messagingSenderId: "36367248676",
    appId: "1:36367248676:web:0e1490f81e663bf44297b1",
    measurementId: "G-8Q5T203WGK",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWrD5133gK25Iv3nJKxIm3kSxHCUVMZNk',
    authDomain: 'workout-organiser-6bebb.firebaseapp.com',
    projectId: 'workout-organiser-6bebb',
    storageBucket: 'workout-organiser-6bebb.appspot.com',
    messagingSenderId: '36367248676',
    appId: '1:36367248676:android:f08a96176a1698b54297b1',
  );
}
