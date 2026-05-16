import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;
  static bool _initialized = false;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  static SharedPreferences get instance {
    if (!_initialized) {
      throw Exception('SharedPrefs not initialized. Call init() first.');
    }
    return _prefs;
  }

  // ==================== BOOLEAN ====================

  static Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static bool getBoolOrDefault(String key, bool defaultValue) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  // ==================== STRING ====================

  static Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static String getStringOrDefault(String key, String defaultValue) {
    return _prefs.getString(key) ?? defaultValue;
  }

  // ==================== INT ====================

  static Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static int getIntOrDefault(String key, int defaultValue) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  // ==================== DOUBLE ====================

  static Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static double getDoubleOrDefault(String key, double defaultValue) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  // ==================== STRING LIST ====================

  static Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  static List<String> getStringListOrDefault(
    String key,
    List<String> defaultValue,
  ) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  // ==================== EXISTS ====================

  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // ==================== REMOVE ====================

  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // ==================== CLEAR ====================

  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  // ==================== APP SPECIFIC ====================

  // Remember me
  static Future<void> setRememberMe(bool value) async {
    await saveBool(AppConstants.keyRememberMe, value);
  }

  static bool getRememberMe() {
    return getBoolOrDefault(AppConstants.keyRememberMe, false);
  }

  // Theme mode
  static Future<void> setThemeMode(String mode) async {
    await saveString(AppConstants.keyThemeMode, mode);
  }

  static String getThemeMode() {
    return getStringOrDefault(AppConstants.keyThemeMode, 'dark');
  }

  // Last logged user
  static Future<void> setLastUserId(String userId) async {
    await saveString('last_user_id', userId);
  }

  static String? getLastUserId() {
    return getString('last_user_id');
  }

  // Onboarding completed
  static Future<void> setOnboardingCompleted(bool completed) async {
    await saveBool('onboarding_completed', completed);
  }

  static bool isOnboardingCompleted() {
    return getBoolOrDefault('onboarding_completed', false);
  }

  // Notifications enabled
  static Future<void> setNotificationsEnabled(bool enabled) async {
    await saveBool('notifications_enabled', enabled);
  }

  static bool areNotificationsEnabled() {
    return getBoolOrDefault('notifications_enabled', true);
  }

  // Last notification read timestamp
  static Future<void> setLastNotificationReadAt(DateTime date) async {
    await saveString('last_notification_read_at', date.toIso8601String());
  }

  static DateTime? getLastNotificationReadAt() {
    final dateStr = getString('last_notification_read_at');
    if (dateStr != null) {
      return DateTime.tryParse(dateStr);
    }
    return null;
  }

  // Session timeout preference
  static Future<void> setSessionTimeoutMinutes(int minutes) async {
    await saveInt('session_timeout_minutes', minutes);
  }

  static int getSessionTimeoutMinutes() {
    return getIntOrDefault('session_timeout_minutes', 30);
  }
}
