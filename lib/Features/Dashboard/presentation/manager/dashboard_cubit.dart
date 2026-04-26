import 'dart:async';
import 'package:agriculture_app/Features/Alerts/data/models/alert_model.dart';
import 'package:agriculture_app/Features/Alerts/presentation/view/widgets/alert_severity.dart';
import 'package:agriculture_app/Features/Alerts/data/services/alerts_local_service.dart';
import 'package:agriculture_app/Features/Dashboard/data/services/dashboard_service.dart';
import 'package:agriculture_app/core/services/local_notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  StreamSubscription? _subscription;

  DashboardCubit(this.service) : super(DashboardInitial()) {
    print('[Cubit] 🚀 Initialized');
    loadSavedAlerts();
  }

  // =========================
  // Load Alerts
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
  // Start Listening (REAL-TIME)
  // =========================
  void startFetchingData() {
    emit(DashboardLoading());

    _subscription?.cancel();

    service.connect();

    _subscription = service.stream.listen(
      (data) {
        _updateLiveData(data);
      },
      onError: (e) {
        emit(DashboardError(message: e.toString()));
      },
      onDone: () {
        emit(DashboardDisconnected());
      },
    );

    emit(DashboardConnected(liveData: liveData));
  }

  // =========================
  // Stop Listening
  // =========================
  void stopFetchingData() {
    _subscription?.cancel();
    service.disconnect();
    emit(DashboardDisconnected());
  }

  // =========================
  // Update UI Data
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
      print('[Cubit] ❌ Parse Error: $e');
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

    // Prevent duplicates
    List<Alert> filtered = [];

    for (var alert in newAlerts) {
      bool exists = savedAlerts.any(
        (a) => a.type == alert.type && a.description == alert.description,
      );

      if (!exists) filtered.add(alert);
    }

    if (filtered.isEmpty) return;

    savedAlerts.insertAll(0, filtered);
    await AlertsLocalService.saveAlerts(savedAlerts);

    emit(DashboardAlertsUpdated(alerts: savedAlerts));

    for (var alert in filtered) {
      LocalNotificationService.showNotification(
        title: alert.type,
        body: alert.description,
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    service.disconnect();
    return super.close();
  }
}
