import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorageManager {
  static const String _storageKey = 'persistent_storage';
  static const String _storageVersionKey = 'persistent_storage_version';
  static const String _storageVersion = '1.0.0';

  static Future<void> init() async {
    final String? version = await get(_storageVersionKey);
    if (version == null) {
      await set(_storageVersionKey, _storageVersion);
    } else if (version != _storageVersion) {
      await clear();
      await set(_storageVersionKey, _storageVersion);
    }
  }

  static Future<void> set(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
