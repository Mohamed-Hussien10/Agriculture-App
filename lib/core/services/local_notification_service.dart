import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Local Notification Service
/// Handles all local notifications for the app
/// Supports both Android and iOS platforms
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialize the notification service
  static Future<void> init() async {
    print('[Notification] 🔔 Initializing notification service...');

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    // Combined initialization settings
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      final result = await _flutterLocalNotificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      print('[Notification] ✅ Initialization result: $result');
    } catch (e) {
      print('[Notification] ❌ Initialization failed: $e');
    }
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    print('[Notification] 👆 Notification tapped: ${response.payload}');
  }

  /// Request notification permissions
  /// Returns true if permission is granted
  static Future<bool> requestPermissions() async {
    print('[Notification] 🔐 Requesting notification permissions...');

    // Request Android 13+ permissions
    final androidPlugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      try {
        final granted = await androidPlugin.requestNotificationsPermission();
        print(
          '[Notification] ${granted == true ? "✅" : "❌"} Android permission result: $granted',
        );
        return granted ?? false;
      } catch (e) {
        print('[Notification] ❌ Permission request failed: $e');
        return false;
      }
    }

    // Request iOS permissions
    final iosPlugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    if (iosPlugin != null) {
      try {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        print(
          '[Notification] ${granted == true ? "✅" : "❌"} iOS permission result: $granted',
        );
        return granted ?? false;
      } catch (e) {
        print('[Notification] ❌ iOS Permission request failed: $e');
        return false;
      }
    }

    return false;
  }

  /// Show a local notification
  /// [title] - Notification title
  /// [body] - Notification body text
  /// [payload] - Optional payload data
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    print('[Notification] 📢 Showing notification: $title - $body');

    // Android notification details
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'alerts_channel',
          'Alerts Channel',
          channelDescription: 'Channel for farm alerts',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    // iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Combined notification details
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
        payload: payload,
      );
      print('[Notification] ✅ Notification shown successfully');
    } catch (e) {
      print('[Notification] ❌ Failed to show notification: $e');
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    print('[Notification] 🗑️ Cancelling all notifications');
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Cancel a specific notification by ID
  static Future<void> cancel(int id) async {
    print('[Notification] 🗑️ Cancelling notification: $id');
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
