import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings darwinSettings =
      DarwinInitializationSettings();

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: darwinSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap if needed.
      log('Notification payload: ${response.payload}');
    },
  );
}