import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/shared_prefs.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  String? _accessToken;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _accessToken != null && _currentUser != null;

  AuthProvider() {
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    _accessToken = await SecureStorage.getToken();
    final userJson = await SecureStorage.getUser(
      'user_key',
    ); // Replace 'user_key' with the appropriate key
    if (userJson != null && _accessToken != null) {
      try {
        // TODO: Parsear userJson cuando tengamos el método fromJson completo
        // _currentUser = UserModel.fromJson(jsonDecode(userJson));
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading user data: $e');
      }
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authRepository.login(email, password);

      _accessToken = response.accessToken;
      await SecureStorage.saveToken(response.accessToken);
      await SecureStorage.saveValue('refresh_token', response.refreshToken);

      // Obtener perfil del usuario
      await getCurrentUser();

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(RegisterDto registerData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authRepository.register(registerData);

      _accessToken = response.accessToken;
      await SecureStorage.saveToken(response.accessToken);
      await SecureStorage.saveValue('refresh_token', response.refreshToken);

      await getCurrentUser();

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      _currentUser = user;
      await SecureStorage.saveUser('user_key', user.toJson().toString());
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting current user: $e');
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await SecureStorage.getValue('refresh_token');
      if (refreshToken == null) return false;

      final response = await _authRepository.refreshToken(refreshToken);
      _accessToken = response.accessToken;
      await SecureStorage.saveToken(response.accessToken);
      await SecureStorage.saveValue('refresh_token', response.refreshToken);

      notifyListeners();
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      final refreshToken = await SecureStorage.getValue('refresh_token');
      if (refreshToken != null) {
        await _authRepository.logout(refreshToken);
      }
    } catch (e) {
      debugPrint('Error during logout API call: $e');
    } finally {
      // Limpiar almacenamiento local
      await SecureStorage.clearAll();
      await SharedPrefs.clear();

      _accessToken = null;
      _currentUser = null;
      _setLoading(false);
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.changePassword(currentPassword, newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
