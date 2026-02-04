import 'dart:convert';
import 'package:agriculture_app/Features/Actions/data/models/action_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionsLocalService {
  static const String _keyActions = 'saved_actions';

  // حفظ قائمة الإجراءات
  static Future<void> saveActions(List<ActionItemModel> actions) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        actions.map((action) => jsonEncode(action.toJson())).toList();
    await prefs.setStringList(_keyActions, jsonList);
  }

  // تحميل قائمة الإجراءات
  static Future<List<ActionItemModel>> getActions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keyActions) ?? [];
    return jsonList
        .map((jsonStr) => ActionItemModel.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  // مسح جميع الإجراءات
  static Future<void> clearActions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyActions);
  }
}
