import 'dart:convert';
import 'package:agriculture_app/Features/Alerts/data/models/alert_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertsLocalService {
  static const _key = 'saved_alerts';

  // حفظ التنبيهات
  static Future<void> saveAlerts(List<Alert> alerts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = alerts.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  // جلب التنبيهات
  static Future<List<Alert>> getAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => Alert.fromJson(jsonDecode(e))).toList();
  }
}
