import 'package:aplicacion_avante/core/api/api_endpoints.dart';
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Obtener token
    final token = await SecureStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log de respuestas exitosas
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    print('Mensaje: ${err.message}');

    // Manejar error 401 - Token expirado
    if (err.response?.statusCode == 401) {
      // Intentar refrescar token
      final refreshSuccess = await _refreshToken();

      if (refreshSuccess) {
        // Reintentar la petición original
        final newToken = await SecureStorage.getToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

        final dio = Dio();
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      }
    }

    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await SecureStorage.getValue('refresh_token');
      if (refreshToken == null) return false;

      final dio = Dio();
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.refresh}',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await SecureStorage.saveToken(newAccessToken);
        await SecureStorage.saveValue('refresh_token', newRefreshToken);

        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }
}
