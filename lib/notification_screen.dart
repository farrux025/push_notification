import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final RemoteMessage? message;

  const NotificationScreen({super.key, this.message});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String data = "Notification is empty";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Screen")),
      body: Center(
        child: Text("${widget.message?.notification?.title}\n"
            "${widget.message?.notification?.body}\n"
            "${widget.message?.data}\n"),
      ),
    );
  }
}
