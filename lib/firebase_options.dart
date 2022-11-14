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
    apiKey: 'AIzaSyAkhVRhgJtnDPDnlWqR-hYKjcE9h18Jcjs',
    appId: '1:965848037493:web:03d87d58d321a7030d603c',
    messagingSenderId: '965848037493',
    projectId: 'whatsapp-clone-flutter-fd0c8',
    authDomain: 'whatsapp-clone-flutter-fd0c8.firebaseapp.com',
    databaseURL: 'https://whatsapp-clone-flutter-fd0c8-default-rtdb.firebaseio.com',
    storageBucket: 'whatsapp-clone-flutter-fd0c8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5JwW381x74XZM54dbVJm7WJzl2-b4XFM',
    appId: '1:965848037493:android:0ec0fc2b1e9018660d603c',
    messagingSenderId: '965848037493',
    projectId: 'whatsapp-clone-flutter-fd0c8',
    databaseURL: 'https://whatsapp-clone-flutter-fd0c8-default-rtdb.firebaseio.com',
    storageBucket: 'whatsapp-clone-flutter-fd0c8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAh-KXF0KqhBZLNaSaRYlaP27DszGGradI',
    appId: '1:965848037493:ios:5713de3ea25001a40d603c',
    messagingSenderId: '965848037493',
    projectId: 'whatsapp-clone-flutter-fd0c8',
    databaseURL: 'https://whatsapp-clone-flutter-fd0c8-default-rtdb.firebaseio.com',
    storageBucket: 'whatsapp-clone-flutter-fd0c8.appspot.com',
    iosClientId: '965848037493-g3cfice2h461etolol9q09s9tcoo1ul6.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAh-KXF0KqhBZLNaSaRYlaP27DszGGradI',
    appId: '1:965848037493:ios:5713de3ea25001a40d603c',
    messagingSenderId: '965848037493',
    projectId: 'whatsapp-clone-flutter-fd0c8',
    databaseURL: 'https://whatsapp-clone-flutter-fd0c8-default-rtdb.firebaseio.com',
    storageBucket: 'whatsapp-clone-flutter-fd0c8.appspot.com',
    iosClientId: '965848037493-g3cfice2h461etolol9q09s9tcoo1ul6.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );
}