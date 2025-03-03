import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/features/welcome/splash_screen.dart';
import 'package:task_manager/utils/notifications/notification.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  await initializeNotifications();
  runApp(
    App(
      widget: SplashScreen(),
    ),
  );
}
