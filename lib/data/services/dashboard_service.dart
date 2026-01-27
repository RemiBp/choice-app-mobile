import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class DashboardService {
  final Dio _dio = ApiService().client;

  Future<Map<String, dynamic>> getOverview() async {
    try {
      final response = await _dio.get('/api/producer/dashboard/overview');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserInsights() async {
    try {
      final response = await _dio.get('/api/producer/dashboard/user-insights');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTrends({required String metric, String? from, String? to}) async {
    try {
      final response = await _dio.get(
        '/api/producer/dashboard/trends',
        queryParameters: {
          'metric': metric,
          if (from != null) 'from': from,
          if (to != null) 'to': to,
        },
      );
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getRatings() async {
    try {
      final response = await _dio.get('/api/producer/dashboard/ratings');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFeedback() async {
    try {
      final response = await _dio.get('/api/producer/dashboard/feedback');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBenchmark() async {
    try {
      final response = await _dio.get('/api/producer/dashboard/benchmark');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }
}
