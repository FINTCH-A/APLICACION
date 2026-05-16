// ignore_for_file: unused_import
import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<AuthTokensDto> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: LoginDto(email: email, password: password).toJson(),
    );

    return AuthTokensDto.fromJson(response.data);
  }

  Future<AuthTokensDto> register(RegisterDto registerData) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: registerData.toJson(),
    );

    return AuthTokensDto.fromJson(response.data);
  }

  Future<AuthTokensDto> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refresh,
      data: RefreshTokenDto(refreshToken: refreshToken).toJson(),
    );

    return AuthTokensDto.fromJson(response.data);
  }

  Future<void> logout(String refreshToken) async {
    await _apiClient.post(
      ApiEndpoints.logout,
      data: RefreshTokenDto(refreshToken: refreshToken).toJson(),
    );
  }

  Future<void> logoutAll() async {
    await _apiClient.post(ApiEndpoints.logoutAll);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.me);
    return UserModel.fromJson(response.data);
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _apiClient.post(
      ApiEndpoints.changePassword,
      data: ChangePasswordDto(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ).toJson(),
    );
  }
}
