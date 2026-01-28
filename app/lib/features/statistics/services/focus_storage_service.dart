import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FocusStorageService {
  static const String _paramFocusMap = 'param_focus_history_map';
  static const String _paramIsFocusing = 'param_is_focusing';
  static const String _paramFocusStartTime = 'param_focus_start_time';

  Future<void> saveFocusHistory(Map<String, int> history, {String? key}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(history);
    await prefs.setString(key ?? _paramFocusMap, jsonString);
  }

  Future<Map<String, int>> getFocusHistory({String? key}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key ?? _paramFocusMap);
    
    if (jsonString == null) return {};
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((key, value) => MapEntry(key, value as int));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveFocusState({required bool isFocusing, DateTime? startTime}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_paramIsFocusing, isFocusing);
    if (startTime != null) {
      await prefs.setString(_paramFocusStartTime, startTime.toIso8601String());
    } else {
      await prefs.remove(_paramFocusStartTime);
    }
  }

  Future<(bool, DateTime?)> getFocusState() async {
    final prefs = await SharedPreferences.getInstance();
    final isFocusing = prefs.getBool(_paramIsFocusing) ?? false;
    final startTimeStr = prefs.getString(_paramFocusStartTime);
    DateTime? startTime;
    if (startTimeStr != null) {
      startTime = DateTime.tryParse(startTimeStr);
    }
    return (isFocusing, startTime);
  }
}
