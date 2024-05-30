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
    apiKey: 'AIzaSyBIFssPBGLfI3IgOEreM2uDyqhMuOpkyhg',
    appId: '1:158111326277:web:1a412319c6d03557cf832c',
    messagingSenderId: '158111326277',
    projectId: 'virtual-chef-3d785',
    authDomain: 'virtual-chef-3d785.firebaseapp.com',
    storageBucket: 'virtual-chef-3d785.appspot.com',
    measurementId: 'G-JZJXSTKSKS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDo1P_efmy8crs2YJSi8tLe9KwBGCFhUn8',
    appId: '1:158111326277:android:15f060a13d42e714cf832c',
    messagingSenderId: '158111326277',
    projectId: 'virtual-chef-3d785',
    storageBucket: 'virtual-chef-3d785.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKNGCdXy7TL8yslJZsgYWC8B8onNJNK7g',
    appId: '1:158111326277:ios:b5cd8564b30630dbcf832c',
    messagingSenderId: '158111326277',
    projectId: 'virtual-chef-3d785',
    storageBucket: 'virtual-chef-3d785.appspot.com',
    androidClientId: '158111326277-ehdj0jvjvo3pjkkdmj4hupt1lrlmvhqe.apps.googleusercontent.com',
    iosClientId: '158111326277-85ahqkh11pdp6hggj7qsttoua5jri4mk.apps.googleusercontent.com',
    iosBundleId: 'com.example.finallllmobileeeee',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKNGCdXy7TL8yslJZsgYWC8B8onNJNK7g',
    appId: '1:158111326277:ios:b5cd8564b30630dbcf832c',
    messagingSenderId: '158111326277',
    projectId: 'virtual-chef-3d785',
    storageBucket: 'virtual-chef-3d785.appspot.com',
    androidClientId: '158111326277-ehdj0jvjvo3pjkkdmj4hupt1lrlmvhqe.apps.googleusercontent.com',
    iosClientId: '158111326277-85ahqkh11pdp6hggj7qsttoua5jri4mk.apps.googleusercontent.com',
    iosBundleId: 'com.example.finallllmobileeeee',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBIFssPBGLfI3IgOEreM2uDyqhMuOpkyhg',
    appId: '1:158111326277:web:fa6c2fded8ad8314cf832c',
    messagingSenderId: '158111326277',
    projectId: 'virtual-chef-3d785',
    authDomain: 'virtual-chef-3d785.firebaseapp.com',
    storageBucket: 'virtual-chef-3d785.appspot.com',
    measurementId: 'G-8HPBK50QZ1',
  );
}