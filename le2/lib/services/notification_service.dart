import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await _messaging.subscribeToTopic('daily_recipe');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final title = message.notification!.title ?? 'New recipe';
        final body =
            message.notification!.body ?? 'Check the recipe of the day!';

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title\n$body')));
      }
    });
  }
}
