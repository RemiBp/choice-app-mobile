import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../common/utils.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:6543';
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;

  ApiService._internal() {
    // For physical device via `adb reverse tcp:6543 tcp:6543`, localhost works.
    // For emulator, use 10.0.2.2.

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (object) => debugPrint(object.toString()),
    ));
  }

  Dio get client => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  static String get token => PreferenceUtils.token;
}
