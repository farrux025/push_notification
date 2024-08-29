import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_fcm_sovchi/main.dart';

import '../notification_screen.dart';

class FirebaseApi {
  final _fbMessaging = FirebaseMessaging.instance;

  final _androidChanel = const AndroidNotificationChannel(
      "sovchi_channel", "High Importance Notification",
      description: "", importance: Importance.defaultImportance);

  final _flutterLocalNotification = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _fbMessaging.requestPermission();
    final fCMToken = await _fbMessaging.getToken();
    log("FCM Token: $fCMToken");
    initPushNotifications();
    initLocalNotifications();
  }

  handleMessage(RemoteMessage? message) {
    if (message == null) return;
    MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => NotificationScreen(message: message)));
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings("@drawable/ic_launcher");
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _flutterLocalNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        RemoteMessage message =
            RemoteMessage.fromMap(jsonDecode(details.payload ?? ''));
        handleMessage(message);
      },
    );
    final platform =
        _flutterLocalNotification.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChanel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      handleMessage(value);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });
    FirebaseMessaging.onBackgroundMessage(_fmBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      var notification = message.notification;
      if (notification == null) return;
      _flutterLocalNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChanel.id, _androidChanel.name,
                  channelDescription: _androidChanel.description,
                  icon: "@drawable/ic_launcher")),
          payload: jsonEncode(message.toMap()));
    });
  }
}

Future<void> _fmBackgroundHandler(RemoteMessage message) async {
  log("Title: ${message.notification?.title}");
  log("Body: ${message.notification?.body}");
  log("Message Data: ${message.data}");
  // showLocalNotification(message.notification);
}
