import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // App
  static String get appName => dotenv.env['APP_NAME'] ?? 'AvanteCreditos';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';

  // API
  static String get apiUrl =>
      dotenv.env['API_URL'] ?? 'http://localhost:3000/api/v1';
  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // Features
  static bool get enableBiometrics => dotenv.env['ENABLE_BIOMETRICS'] == 'true';
  static bool get enableNotifications =>
      dotenv.env['ENABLE_NOTIFICATIONS'] != 'false';
  static bool get enableOfflineMode =>
      dotenv.env['ENABLE_OFFLINE_MODE'] == 'true';

  // Storage Keys
  static String get tokenKey => dotenv.env['TOKEN_KEY'] ?? 'auth_token';
  static String get refreshTokenKey =>
      dotenv.env['REFRESH_TOKEN_KEY'] ?? 'refresh_token';
  static String getUserDataKey(String userId) =>
      '${dotenv.env['USER_DATA_KEY'] ?? 'user_data'}_$userId';
  static String get themeKey => dotenv.env['THEME_KEY'] ?? 'theme_mode';

  // Helpers
  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction => appEnv == 'production';
  static bool get isStaging => appEnv == 'staging';
}
