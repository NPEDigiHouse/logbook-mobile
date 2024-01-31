import 'package:data/data.exports.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationUtils {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> configureFirebaseMessaging() async {
    // Set up notification handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received in the foreground: ${message.notification?.body}");
      // Tambahkan logika atau tindakan yang sesuai saat menerima notifikasi di foreground
    });

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Get device token
    try {
      String? token = await _firebaseMessaging.getToken();
      AuthPreferenceHandler.setFCMToken(token);
      print("FCM Token: $token");
    } catch (e) {
      print("Error getting device token: $e");
    }
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print("Handling a background message: ${message.notification?.body}");
    // Tambahkan logika atau tindakan yang sesuai saat aplikasi berjalan di background
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print("Subscribed to $topic");
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print("Unsubscribed from $topic");
  }
}
