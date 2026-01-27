import 'package:choice_app/common/utils.dart';
import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class BookingService {
  final Dio _dio = ApiService().client;

  String get _baseUrl {
    final role = PreferenceUtils.role.toLowerCase();
    return role == 'user' ? '/api/app/booking' : '/api/producer/booking';
  }

  Future<Map<String, dynamic>> getBookings({
    required String type, // 'scheduled', 'inProgress', 'completed', 'cancelled'
    String timeZone = 'UTC',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/getBookings',
        queryParameters: {
          'booking': type,
          'timeZone': timeZone,
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBookingDetails(int id, {String timeZone = 'UTC'}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/getBooking/$id',
        queryParameters: {'timeZone': timeZone},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(int id, String reason, {String timeZone = 'UTC'}) async {
    try {
      await _dio.put(
        '$_baseUrl/cancel/$id',
        data: {'cancelReason': reason},
        queryParameters: {'timeZone': timeZone},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkInBooking(int id, {String timeZone = 'UTC'}) async {
    try {
      // Note: Only producers might have checkIn, but we keep it generic
      await _dio.put(
        '$_baseUrl/checkIn/$id',
        queryParameters: {'timeZone': timeZone},
      );
    } catch (e) {
      rethrow;
    }
  }
}
