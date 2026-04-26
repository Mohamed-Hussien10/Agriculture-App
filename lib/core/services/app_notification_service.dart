import 'package:agriculture_app/core/services/local_notification_service.dart';

/// Global notification service for the entire app
/// Works in foreground and when app is in background
class AppNotificationService {
  /// Initialize notification service
  static Future<void> init() async {
    await LocalNotificationService.init();
    await LocalNotificationService.requestPermissions();
  }

  /// Show pest detection alert
  static Future<void> showPestAlert(String pestName, double confidence) async {
    final confidencePercent = (confidence * 100).toStringAsFixed(1);
    
    await LocalNotificationService.showNotification(
      title: '⚠️ Pest Detected!',
      body: '$pestName detected with $confidencePercent% confidence',
    );
  }

  /// Show general notification
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await LocalNotificationService.showNotification(
      title: title,
      body: body,
      payload: payload,
    );
  }

  /// Show weather alert
  static Future<void> showWeatherAlert(String message) async {
    await LocalNotificationService.showNotification(
      title: '🌤️ Weather Alert',
      body: message,
    );
  }

  /// Show watering reminder
  static Future<void> showWateringReminder() async {
    await LocalNotificationService.showNotification(
      title: '💧 Watering Reminder',
      body: 'Your plants need water! Check the irrigation status.',
    );
  }

  /// Show fertilizing reminder
  static Future<void> showFertilizingReminder() async {
    await LocalNotificationService.showNotification(
      title: '🌱 Fertilizing Reminder',
      body: 'Time to fertilize your crops for better growth!',
    );
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await LocalNotificationService.cancelAll();
  }
}