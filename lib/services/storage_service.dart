import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences so the rest of the app never
/// touches the plugin directly.
class StorageService {
  static const String _historyKey = 'cg_history_records';

  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  Future<void> saveJsonList(String key, List<Map<String, dynamic>> list) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(list));
  }

  Future<List<Map<String, dynamic>>> readJsonList(String key) async {
    final prefs = await _prefs;
    final raw = prefs.getString(key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveHistory(List<Map<String, dynamic>> records) =>
      saveJsonList(_historyKey, records);

  Future<List<Map<String, dynamic>>> readHistory() => readJsonList(_historyKey);

  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }
}
