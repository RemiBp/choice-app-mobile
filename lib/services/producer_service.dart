import 'dart:io';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'api_service.dart';
import 'auth_service.dart';

final _dio = ApiService.dio;

// ─────────────────────────────────────────────
// Profile
// ─────────────────────────────────────────────

class ProducerProfileService {
  static Future<AuthResult> getProfile() async {
    try {
      final r = await _dio.get('${AppConfig.producerProfilePath}/getProfile');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> updateProfile(Map<String, dynamic> body) async {
    try {
      final r = await _dio.put('${AppConfig.producerProfilePath}/updateProfile', data: body);
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final r = await _dio.post(
        '${AppConfig.producerProfilePath}/changeCurrentPassword',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getNotifications() async {
    try {
      final r = await _dio.get('${AppConfig.producerProfilePath}/getNotifications');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getOperationalHours() async {
    try {
      final r = await _dio.get('${AppConfig.producerProfilePath}/getOperationalHours');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> setOperationalHours(Map<String, dynamic> body) async {
    try {
      final r = await _dio.post('${AppConfig.producerProfilePath}/setOperationalHours', data: body);
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getGalleryImages() async {
    try {
      final r = await _dio.get('${AppConfig.producerProfilePath}/getGalleryImages');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getMenu() async {
    try {
      final r = await _dio.get('${AppConfig.producerProfilePath}/getMenu');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> reviewsAndRating() async {
    try {
      final r = await _dio.get('${AppConfig.producerProfilePath}/reviewsAndRating');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> bookingChart() async {
    try {
      final r = await _dio.get('${AppConfig.producerProfilePath}/bookingChart');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> customerChart() async {
    try {
      final r = await _dio.get('${AppConfig.producerProfilePath}/customerChart');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getPreSignedUrl({
    required String fileName,
    required String contentType,
    required String folderName,
  }) async {
    try {
      final r = await _dio.post(
        '${AppConfig.producerProfilePath}/getPreSignedUrl',
        data: {'fileName': fileName, 'contentType': contentType, 'folderName': folderName},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<bool> uploadToS3({
    required String presignedUrl,
    required File file,
    required String contentType,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final dio = Dio();
      final response = await dio.put(
        presignedUrl,
        data: Stream.fromIterable(bytes.map((e) => [e])),
        options: Options(
          headers: {
            Headers.contentLengthHeader: bytes.length,
            'Content-Type': contentType,
          },
          followRedirects: false,
          validateStatus: (s) => s != null && s < 400,
        ),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}

// ─────────────────────────────────────────────
// Posts / Feed
// ─────────────────────────────────────────────

class ProducerPostService {
  static Future<AuthResult> getMyPosts({int page = 1, int limit = 20}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.producerPostPath}/getMyPosts',
        queryParameters: {'page': page, 'limit': limit},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getUserPosts({int page = 1, int limit = 20}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.producerPostPath}/getUserPosts',
        queryParameters: {'page': page, 'limit': limit},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getPostsByProducer({int page = 1, int limit = 20}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.producerPostPath}/getPostsByProducer',
        queryParameters: {'page': page, 'limit': limit},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> createProducerPost(Map<String, dynamic> body) async {
    try {
      final r = await _dio.post('${AppConfig.producerPostPath}/createProducerPost', data: body);
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> toggleLike(int postId) async {
    try {
      final r = await _dio.post('${AppConfig.producerPostPath}/togglePostLike/$postId');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> addComment(int postId, String content) async {
    try {
      final r = await _dio.post(
        '${AppConfig.producerPostPath}/addCommentToPost/$postId',
        data: {'content': content},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getComments(int postId) async {
    try {
      final r = await _dio.get('${AppConfig.producerPostPath}/getCommentsByPost/$postId');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> deletePost(int postId) async {
    try {
      final r = await _dio.delete('${AppConfig.producerPostPath}/deletePost/$postId');
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> toggleFollowProducer(int producerId) async {
    try {
      final r = await _dio.post(
        '${AppConfig.producerPostPath}/toggleFollowProducer',
        data: {'producerId': producerId},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }
}

// ─────────────────────────────────────────────
// Events
// ─────────────────────────────────────────────

class ProducerEventService {
  static Future<AuthResult> getMyEvents({int page = 1, int limit = 20}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.producerEventPath}/getMyEvents',
        queryParameters: {'page': page, 'limit': limit},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getAllEvents({int page = 1, int limit = 20}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.producerEventPath}/getAllEvents',
        queryParameters: {'page': page, 'limit': limit},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getEventTypes() async {
    try {
      final r = await _dio.get('${AppConfig.producerEventPath}/getEventTypes');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> createEvent(Map<String, dynamic> body) async {
    try {
      final r = await _dio.post('${AppConfig.producerEventPath}/createEvent', data: body);
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> updateEvent(int eventId, Map<String, dynamic> body) async {
    try {
      final r = await _dio.put('${AppConfig.producerEventPath}/updateEvent/$eventId', data: body);
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> deleteEvent(int eventId) async {
    try {
      final r = await _dio.delete('${AppConfig.producerEventPath}/deleteEvent/$eventId');
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }
}

// ─────────────────────────────────────────────
// Bookings
// ─────────────────────────────────────────────

class ProducerBookingService {
  static Future<AuthResult> getBookings({String? status, int page = 1, int limit = 20}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.producerBookingPath}/getBookings',
        queryParameters: {
          if (status != null) 'booking': status,
          'page': page,
          'limit': limit,
          'timeZone': DateTime.now().timeZoneName,
        },
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getUserBookings({int page = 1, int limit = 20}) async {
    try {
      final r = await _dio.get(
        '${AppConfig.producerBookingPath}/getUserBookings',
        queryParameters: {'page': page, 'limit': limit},
      );
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> cancelBooking(int bookingId) async {
    try {
      final r = await _dio.put('${AppConfig.producerBookingPath}/cancel/$bookingId');
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> checkIn(int bookingId) async {
    try {
      final r = await _dio.put('${AppConfig.producerBookingPath}/checkIn/$bookingId');
      return AuthResult(success: true, message: r.data['message'] as String?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }
}

// ─────────────────────────────────────────────
// Dashboard
// ─────────────────────────────────────────────

class ProducerDashboardService {
  static Future<AuthResult> getOverview() async {
    try {
      final r = await _dio.get('${AppConfig.producerDashboardPath}/overview');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getRatings() async {
    try {
      final r = await _dio.get('${AppConfig.producerDashboardPath}/ratings');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getTrends() async {
    try {
      final r = await _dio.get('${AppConfig.producerDashboardPath}/trends');
      return AuthResult(success: true, data: r.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      return AuthResult(success: false, message: _err(e));
    }
  }

  static Future<AuthResult> getUserInsights() async {
    try {
      final r = await _dio.get('${AppConfig.producerDashboardPath}/user-insights');
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
