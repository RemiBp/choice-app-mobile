
import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class CustomerService {
  final Dio _dio = ApiService().client;

  Future<List<dynamic>> getUserFeed() async {
    try {
      final response = await _dio.get('/api/producer/post/getUserPosts');
      return response.data['data'] ?? [];
    } catch (e) {
      // If 404 or empty, return empty list
      return [];
    }
  }
}
