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
    apiKey: 'AIzaSyB-reiQfpkY8a38JdRSMzA-qIwmy3bzMWE',
    appId: '1:52754735379:android:65cae8f766b5b7bb53fae6',
    messagingSenderId: '52754735379',
    projectId: 'discover-egypt-95efd',
    storageBucket: 'discover-egypt-95efd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeSXuDrVMMVe3RkD5W5Vedp0kjUQ0ekco',
    appId: '1:52754735379:ios:af9972872d624fb953fae6',
    messagingSenderId: '52754735379',
    projectId: 'discover-egypt-95efd',
    storageBucket: 'discover-egypt-95efd.firebasestorage.app',
    iosBundleId: 'com.discoveregypt.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB-reiQfpkY8a38JdRSMzA-qIwmy3bzMWE',
    appId: '1:52754735379:web:65cae8f766b5b7bb53fae6',
    messagingSenderId: '52754735379',
    projectId: 'discover-egypt-95efd',
    authDomain: 'discover-egypt-95efd.firebaseapp.com',
    storageBucket: 'discover-egypt-95efd.firebasestorage.app',
  );
}
