import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'api_service.dart';
import 'auth_service.dart';
import 'storage_service.dart';

final _dio = ApiService.dio;

// ─────────────────────────────────────────────
// Customer Auth (app users)
// ─────────────────────────────────────────────

class CustomerAuthService {
  static Future<AuthResult> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final r = await _dio.post(
        '${AppConfig.appAuthPath}/register',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          if (fullName != null && fullName.isNotEmpty) 'fullName': fullName.trim(),
        },
      );
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> login({
    required String email,
    required String password,
    String deviceId = 'web',
  }) async {
    try {
      final r = await _dio.post(
        '${AppConfig.appAuthPath}/login',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          'deviceId': deviceId,
        },
      );
      final data = r.data as Map<String, dynamic>;
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken != null && refreshToken != null) {
        await StorageService.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
        await StorageService.saveUserEmail(email.trim().toLowerCase());
        await StorageService.saveUserRole('user');
      }
      return AuthResult(
        success: true,
        message: data['isVerified'] == false && accessToken == null ? 'needs_otp' : data['message'] as String?,
        data: data,
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> verifyOtp({required String email, required String otp}) async {
    try {
      final r = await _dio.post(
        '${AppConfig.appAuthPath}/verifyOtp',
        data: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );
      final data = r.data as Map<String, dynamic>;
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken != null && refreshToken != null) {
        await StorageService.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
        await StorageService.saveUserRole('user');
      }
      return AuthResult(success: true, message: data['message'] as String?, data: data);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }
}

// ─────────────────────────────────────────────
// Customer Profile
// ─────────────────────────────────────────────

class CustomerProfileService {
  static Future<AuthResult> getProfile() async {
    try {
      final r = await _dio.get('${AppConfig.appProfilePath}/getProfile');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> updateProfile(Map<String, dynamic> body) async {
    try {
      final r = await _dio.put('${AppConfig.appProfilePath}/updateProfile', data: body);
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> searchUsers(String query) async {
    try {
      final r = await _dio.get(
        '${AppConfig.appProfilePath}/searchUsers',
        queryParameters: {'search': query},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getNotifications() async {
    try {
      final r = await _dio.get('${AppConfig.appProfilePath}/getNotifications');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getFavouriteRestaurants() async {
    try {
      final r = await _dio.get('${AppConfig.appProfilePath}/getFavouriteRestaurants');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> addFavourite(int restaurantId) async {
    try {
      final r = await _dio.put('${AppConfig.appProfilePath}/addFavouriteRestaurant/$restaurantId');
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> removeFavourite(int restaurantId) async {
    try {
      final r = await _dio.delete('${AppConfig.appProfilePath}/removeFavouriteRestaurant/$restaurantId');
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }
}

// ─────────────────────────────────────────────
// Customer Bookings
// ─────────────────────────────────────────────

class CustomerBookingService {
  static Future<AuthResult> findRestaurantsNearby({
    required double latitude,
    required double longitude,
    double radius = 5000,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final r = await _dio.post(
        '${AppConfig.appBookingPath}/findRestaurantsNearby',
        data: {'latitude': latitude, 'longitude': longitude, 'radius': radius, 'page': page, 'limit': limit},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getBookings({String? status, int page = 1, int limit = 20}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.appBookingPath}/getBookings',
        queryParameters: {
          if (status != null) 'status': status,
          'page': page,
          'limit': limit,
        },
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> createBooking(Map<String, dynamic> body) async {
    try {
      final r = await _dio.post('${AppConfig.appBookingPath}/createBooking', data: body);
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> cancelBooking(int bookingId) async {
    try {
      final r = await _dio.put('${AppConfig.appBookingPath}/cancel/$bookingId');
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> addReview(int bookingId, Map<String, dynamic> body) async {
    try {
      final r = await _dio.put('${AppConfig.appBookingPath}/addReview/$bookingId', data: body);
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }
}

// ─────────────────────────────────────────────
// Customer Post / Ratings
// ─────────────────────────────────────────────

class CustomerPostService {
  static Future<AuthResult> saveRatings(Map<String, dynamic> body) async {
    try {
      final r = await _dio.post('${AppConfig.appPostPath}/saveRatings', data: body);
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }
}

// ─────────────────────────────────────────────
// Maps / Explore
// ─────────────────────────────────────────────

class CustomerMapsService {
  static Future<AuthResult> getNearbyProducers({
    required double latitude,
    required double longitude,
    double radius = 5000,
    String? type,
  }) async {
    try {
      final r = await _dio.get(
        '${AppConfig.appMapsPath}/getNearbyProducers',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          if (type != null) 'type': type,
        },
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> searchProducers(String query, {String type = 'all'}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.appMapsPath}/search',
        queryParameters: {
          'query': query,
          'type': type,
        },
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getProducerDetails(int producerId) async {
    try {
      final r = await _dio.get('${AppConfig.appMapsPath}/getProducerDetails/$producerId');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }
}

String _err(DioException e) {
  try {
    final b = e.response?.data;
    if (b is Map) return b['message'] as String? ?? b['error'] as String? ?? 'Error';
  } catch (_) {}
  return e.message ?? 'Error';
}
