import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'storage_service.dart';

class ApiService {
  static final Dio _dio = _buildDio();

  static Dio get dio => _dio;

  static Dio _buildDio() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            // Retry original request with new token
            final token = await StorageService.getAccessToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final retryResponse = await _dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          }
          // Refresh failed — clear tokens so the app redirects to login
          await StorageService.clearAll();
        }
        handler.next(error);
      },
    ));

    return dio;
  }

  static Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${AppConfig.baseUrl}${AppConfig.producerAuthPath}/refreshAccessToken',
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final newAccess = response.data['data']?['accessToken'] as String?;
      final newRefresh = response.data['data']?['refreshToken'] as String?;
      if (newAccess != null && newRefresh != null) {
        await StorageService.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
