import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthResult {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  const AuthResult({required this.success, this.message, this.data});
}

class AuthService {
  static final _dio = ApiService.dio;

  // Producer register: POST /api/producer/auth/register
  // Body: { email, password, businessName?, role? }
  // Returns: { message }
  static Future<AuthResult> producerRegister({
    required String email,
    required String password,
    String? businessName,
    String? role,
  }) async {
    try {
      final resp = await _dio.post(
        '${AppConfig.producerAuthPath}/register',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          if (businessName != null && businessName.isNotEmpty)
            'businessName': businessName.trim(),
          if (role != null && role != 'user') 'role': role,
        },
      );
      return AuthResult(
        success: true,
        message: resp.data['message'] as String?,
        data: resp.data as Map<String, dynamic>?,
      );
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        message: _extractError(e),
      );
    }
  }

  // Producer login: POST /api/producer/auth/login
  // Body: { email, password, deviceId }
  // Returns: { user, accessToken, refreshToken, isVerified }
  // If isVerified=false, tokens are null and OTP is required.
  static Future<AuthResult> producerLogin({
    required String email,
    required String password,
    String deviceId = 'web',
  }) async {
    try {
      final resp = await _dio.post(
        '${AppConfig.producerAuthPath}/login',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          'deviceId': deviceId,
        },
      );
      final data = resp.data as Map<String, dynamic>;
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken != null && refreshToken != null) {
        await StorageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        await StorageService.saveUserEmail(email.trim().toLowerCase());
        await StorageService.saveUserRole('producer');
      }
      return AuthResult(
        success: true,
        // needsOtp = true when backend says account is not yet verified
        message: data['isVerified'] == false && accessToken == null
            ? 'needs_otp'
            : data['message'] as String?,
        data: data,
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractError(e));
    }
  }

  // Producer verify OTP: POST /api/producer/auth/verifyOtp
  // Body: { email, otp }
  // Returns: { message, email, role, accessToken, refreshToken }
  static Future<AuthResult> producerVerifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final resp = await _dio.post(
        '${AppConfig.producerAuthPath}/verifyOtp',
        data: {
          'email': email.trim().toLowerCase(),
          'otp': otp.trim(),
        },
      );
      final data = resp.data as Map<String, dynamic>;
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken != null && refreshToken != null) {
        await StorageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        await StorageService.saveUserEmail(email.trim().toLowerCase());
        await StorageService.saveUserRole('producer');
      }
      return AuthResult(success: true, message: data['message'] as String?, data: data);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractError(e));
    }
  }

  // Resend sign-up OTP: POST /api/producer/auth/resendSignUpOtp
  static Future<AuthResult> producerResendOtp({required String email}) async {
    try {
      final resp = await _dio.post(
        '${AppConfig.producerAuthPath}/resendSignUpOtp',
        data: {'email': email.trim().toLowerCase()},
      );
      return AuthResult(
        success: true,
        message: resp.data['message'] as String?,
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractError(e));
    }
  }

  // Forgot password: POST /api/producer/auth/forgotPassword
  static Future<AuthResult> producerForgotPassword({required String email}) async {
    try {
      final resp = await _dio.post(
        '${AppConfig.producerAuthPath}/forgotPassword',
        data: {'email': email.trim().toLowerCase()},
      );
      return AuthResult(
        success: true,
        message: resp.data['message'] as String?,
        data: {'email': email.trim().toLowerCase()},
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractError(e));
    }
  }

  // Verify forgot-password OTP: POST /api/producer/auth/verifyForgotPasswordOtp
  static Future<AuthResult> producerVerifyForgotOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final resp = await _dio.post(
        '${AppConfig.producerAuthPath}/verifyForgotPasswordOtp',
        data: {
          'email': email.trim().toLowerCase(),
          'otp': otp.trim(),
        },
      );
      return AuthResult(success: true, message: resp.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractError(e));
    }
  }

  // Reset password: POST /api/producer/auth/resetPassword
  static Future<AuthResult> producerResetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final resp = await _dio.post(
        '${AppConfig.producerAuthPath}/resetPassword',
        data: {
          'email': email.trim().toLowerCase(),
          'otp': otp.trim(),
          'password': password,
        },
      );
      return AuthResult(success: true, message: resp.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _extractError(e));
    }
  }

  static Future<void> logout() => StorageService.clearAll();

  static String _extractError(DioException e) {
    try {
      final body = e.response?.data;
      if (body is Map) {
        return body['message'] as String? ??
            body['error'] as String? ??
            'An error occurred';
      }
    } catch (_) {}
    return e.message ?? 'An error occurred';
  }
}
