import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/env.dart';
import '../constants/app_constants.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.keyToken, value: token);
  }

  // Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.keyToken);
  }

  // Eliminar token
  static Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.keyToken);
  }

  // Guardar refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.keyRefreshToken, value: token);
  }

  // Obtener refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.keyRefreshToken);
  }

  // Eliminar refresh token
  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: AppConstants.keyRefreshToken);
  }

  // Guardar usuario (como JSON string)
  static Future<void> saveUser(String userId, String userJson) async {
    final key = Env.getUserDataKey(userId);
    await _storage.write(key: key, value: userJson);
  }

  // Obtener usuario
  static Future<String?> getUser(String userId) async {
    final key = Env.getUserDataKey(userId);
    return await _storage.read(key: key);
  }

  // Eliminar usuario
  static Future<void> deleteUser(String userId) async {
    final key = Env.getUserDataKey(userId);
    await _storage.delete(key: key);
  }

  // Limpiar todo
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Guardar valor genérico
  static Future<void> saveValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Obtener valor genérico
  static Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  // Eliminar valor genérico
  static Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }
}
