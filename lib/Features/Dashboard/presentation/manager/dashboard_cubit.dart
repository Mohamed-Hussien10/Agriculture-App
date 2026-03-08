import 'dart:async';
import 'package:agriculture_app/Features/Alerts/data/models/alert_model.dart';
import 'package:agriculture_app/Features/Alerts/presentation/view/widgets/alert_severity.dart';
import 'package:agriculture_app/Features/Alerts/data/services/alerts_local_service.dart';
import 'package:agriculture_app/Features/Dashboard/data/services/dashboard_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardService service;

  Map<String, String> liveData = {
    'temperature': '--',
    'humidity': '--',
    'motion': '--',
    'soil': '--',
  };

  List<Alert> savedAlerts = [];
  Timer? _timer;

  DashboardCubit(this.service) : super(DashboardInitial()) {
    print('[Cubit] 🚀 DashboardCubit initialized');
    loadSavedAlerts();
  }

  // =========================
  // Load saved alerts
  // =========================
  Future<void> loadSavedAlerts() async {
    savedAlerts = await AlertsLocalService.getAlerts();
    if (savedAlerts.isNotEmpty) {
      emit(DashboardAlertsUpdated(alerts: savedAlerts));
    }
  }

  Future<void> clearAlerts() async {
    savedAlerts.clear();
    await AlertsLocalService.saveAlerts(savedAlerts);
    emit(DashboardAlertsUpdated(alerts: savedAlerts));
  }

  // =========================
  // Start Fetching Sensor Data
  // =========================
  Future<void> startFetchingData() async {
    emit(DashboardLoading());

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final data = await service.getSensorData();
        _updateLiveData(data);
      } catch (e) {
        emit(DashboardError(message: e.toString()));
      }
    });

    emit(DashboardConnected(liveData: liveData));
  }

  // =========================
  // Stop Fetching
  // =========================
  void stopFetchingData() {
    _timer?.cancel();
    emit(DashboardDisconnected());
  }

  // =========================
  // Update Live Data
  // =========================
  void _updateLiveData(Map<String, dynamic> data) {
    try {
      liveData = {
        'temperature':
            data['temperature'] != null ? '${data['temperature']}°C' : '--',
        'humidity': data['humidity'] != null ? '${data['humidity']}%' : '--',
        'motion':
            data['motion'] != null ? (data['motion'] ? 'نعم' : 'لا') : '--',
        'soil': data['soil'] != null ? '${data['soil']}%' : '--',
      };

      emit(DashboardLiveUpdated(liveData: liveData));

      _checkAlerts(liveData);
    } catch (e) {
      print('[Cubit][ParseError] ❌ Failed to parse live data: $e');
    }
  }

  // =========================
  // Alerts Logic
  // =========================
  Future<void> _checkAlerts(Map<String, String> liveData) async {
    final temp = double.tryParse(
      liveData['temperature']?.replaceAll('°C', '') ?? '',
    );

    final humidity = double.tryParse(
      liveData['humidity']?.replaceAll('%', '') ?? '',
    );

    final motion = liveData['motion'];

    final now = DateTime.now();

    final timestamp =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    List<Alert> newAlerts = [];

    if (motion == 'نعم') {
      newAlerts.add(
        Alert(
          type: "حركة غير طبيعية",
          severity: AlertSeverity.critical,
          description: "تم رصد حركة غير متوقعة في الصوبة.",
          environmentStatus:
              "درجة الحرارة: ${temp ?? '--'} م° | الرطوبة: ${humidity ?? '--'}%",
          timestamp: timestamp,
        ),
      );
    }

    if (humidity != null && (humidity < 50 || humidity > 70)) {
      newAlerts.add(
        Alert(
          type: "تنبيه الرطوبة",
          severity: AlertSeverity.warning,
          description: "الرطوبة خارج النطاق المثالي: $humidity%",
          environmentStatus:
              "درجة الحرارة: ${temp ?? '--'} م° | الرطوبة: $humidity%",
          timestamp: timestamp,
        ),
      );
    }

    if (temp != null && (temp < 20 || temp > 35)) {
      newAlerts.add(
        Alert(
          type: "تنبيه الحرارة",
          severity: AlertSeverity.warning,
          description: "درجة الحرارة خارج النطاق المثالي: $temp م°",
          environmentStatus:
              "درجة الحرارة: $temp م° | الرطوبة: ${humidity ?? '--'}%",
          timestamp: timestamp,
        ),
      );
    }

    // Remove duplicates
    List<Alert> filteredNewAlerts = [];

    for (var alert in newAlerts) {
      bool exists = savedAlerts.any(
        (a) => a.type == alert.type && a.description == alert.description,
      );

      if (!exists) {
        filteredNewAlerts.add(alert);
      }
    }

    if (filteredNewAlerts.isEmpty) return;

    savedAlerts.insertAll(0, filteredNewAlerts);

    await AlertsLocalService.saveAlerts(savedAlerts);

    emit(DashboardAlertsUpdated(alerts: savedAlerts));

    for (var alert in filteredNewAlerts) {
      LocalNotificationService.showNotification(
        title: alert.type,
        body: alert.description,
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

// =========================
// Local Notification Service
// =========================

class LocalNotificationService {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'alerts_channel',
          'Alerts Channel',
          channelDescription: 'Channel for farm alerts',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(0, title, body, details);
  }
}
