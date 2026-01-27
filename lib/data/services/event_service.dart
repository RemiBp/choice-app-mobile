
import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class EventService {
  final Dio _dio = ApiService().client;

  // Get Event Types
  Future<List<dynamic>> getEventTypes() async {
    try {
      final response = await _dio.get('/api/producer/event/getEventTypes');
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Create Event
  Future<Map<String, dynamic>> createEvent({
    required String title,
    String? description,
    String? venueName,
    required String location,
    required double pricePerGuest,
    required int maxCapacity,
    required String date,
    required String startTime,
    required String endTime,
    List<String>? eventImages,
    int? eventTypeId,
    required String serviceType,
    String? status,
  }) async {
    try {
      final response = await _dio.post('/api/producer/event/createEvent', data: {
        'title': title,
        'description': description,
        'venueName': venueName,
        'location': location,
        'pricePerGuest': pricePerGuest,
        'maxCapacity': maxCapacity,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'eventImages': eventImages,
        'eventImages': eventImages,
        'eventTypeId': eventTypeId,
        'serviceType': serviceType, 
        'status': status ?? 'active',
      });
      return response.data;
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Get My Events
  Future<List<dynamic>> getMyEvents() async {
    try {
      final response = await _dio.get('/api/producer/event/getMyEvents');
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

   // Get All Events (Explore)
  Future<List<dynamic>> getAllEvents() async {
    try {
      final response = await _dio.get('/api/producer/event/getAllEvents');
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
