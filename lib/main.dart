import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:test_fcm_sovchi/api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: androidFirebaseOptions);
  await FirebaseApi().initNotifications();

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   log("Message received: ${message.notification?.title}, "
  //       "\n${message.notification?.body},"
  //       "\n${message.data},"
  //       "\n${message.notification?.android?.imageUrl}");
  //
  //   // showLocalNotification(message.notification);
  // });
  //
  // FirebaseMessaging.onBackgroundMessage(_fmBackgroundHandler);
  runApp(const MyApp());
}

///  FCM Token: f-lTglAdQN29d8u57PyMZ0:APA91bEt_kTDsScU9BmQSIHcZ563sfh8AfK7KfRWoQD_-cYwBt3amaAm9SY_6aepe9Yc1fJIUD39tfTEXYlyvBxJjsHUXgzBRV7Al0UVyHPHrjuSZNJVrhBw2WL9UgN8tO-cBdiOkWbj
/// FCM Token new: fiFcsLb3R2SIJkITSG9i-O:APA91bFKFod8BKUWeWj7cT8SOvcva8hJQeXhMS1b-y2838tWxVnmpoQ93LVa__0FbVoZRpoY1lru5u1eguD8SnBrg3vn40Hdbb0pHuh86uVrbR4pI07uevROO6-0u5LjTXkzpswvFmCe
Future<void> _fmBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handled backgroundMessage: ${message.messageId}");
  // showLocalNotification(message.notification);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String token = "";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Test FCM Sovchi"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                onPressed: () async {
                  var fmToken = await firebaseMessaging.getToken();
                  setState(() {
                    token = fmToken ?? "Error";
                  });
                  log("Firebase token: $token");
                },
                child: const Text("GET TOKEN")),
            const SizedBox(height: 20),
            Text(token)
          ],
        ),
      ),
    );
  }
}

const FirebaseOptions androidFirebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyAASPq5Iow3H1SzZwRZGS4FmTIq1O_mf8E',
  appId: '1:218407656598:android:ca15e583a4237320eef6b7',
  messagingSenderId: '218407656598',
  projectId: 'testfcmsovchi',
  storageBucket: 'testfcmsovchi.appspot.com',
);
