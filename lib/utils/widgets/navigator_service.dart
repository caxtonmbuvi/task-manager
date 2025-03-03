import 'package:flutter/material.dart';
import 'package:task_manager/utils/routes/routes.dart';

class NavigatorService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static Future<Object?>? navigateToNotifications({Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(Routes.notifications, arguments: arguments);
  }

  // Optionally, add other navigation methods as needed.
}
