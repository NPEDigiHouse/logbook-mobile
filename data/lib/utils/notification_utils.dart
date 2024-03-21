// ignore_for_file: depend_on_referenced_packages

import 'package:core/context/navigation_extension.dart';
import 'package:common/features/notification/notification_page.dart';
import 'package:data/data.exports.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationUtils {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> init() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print(token);
      AuthPreferenceHandler.setFCMToken(token);
      print("FCM Token: $token");
    } catch (e) {
      print("Error getting device token: $e");
    }
  }

  static Future<void> configureFirebaseMessaging(
      BuildContext context, UserRole role) async {
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(context, message, role);
    });
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print("Handling a background message: ${message.notification?.body}");
    // Tambahkan logika atau tindakan yang sesuai saat aplikasi berjalan di background
  }

  static void _handleNotificationTap(
      BuildContext context, RemoteMessage message, UserRole role) {
    context.navigateTo(NotificationPage(
      role: role,
    ));
  }
}
