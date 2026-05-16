import 'env.dart';

class AppConstants {
  static String get appName => Env.appName;
  static String get appVersion => Env.appVersion;

  // Timeouts (ahora desde .env)
  static Duration get connectionTimeout =>
      Duration(milliseconds: Env.apiTimeout);
  static Duration get receiveTimeout => Duration(milliseconds: Env.apiTimeout);

  // Paginación
  static const int pageSize = 20;

  // Formatos
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss';

  // Keys para almacenamiento (ahora desde .env)
  static String get keyToken => Env.tokenKey;
  static String get keyRefreshToken => Env.refreshTokenKey;
  static String get keyRememberMe => 'remember_me';
  static String get keyThemeMode => Env.themeKey;

  // Features
  static bool get enableBiometrics => Env.enableBiometrics;
  static bool get enableNotifications => Env.enableNotifications;
  static bool get enableOfflineMode => Env.enableOfflineMode;

  // URLs
  static String get apiBaseUrl => Env.apiUrl;
}
