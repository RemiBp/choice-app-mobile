
import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class ProducerPostService {
  final Dio _dio = ApiService().client;

  Future<List<dynamic>> getMyPosts() async {
    try {
      final response = await _dio.get('/api/producer/post/getMyPosts');
      return response.data['data'] ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> createProducerPost(Map<String, dynamic> postData) async {
    try {
      final response = await _dio.post('/api/producer/post/createProducerPost', data: postData);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> togglePostLike(int postId) async {
    try {
      await _dio.post('/api/producer/post/togglePostLike/$postId');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFollowProducer(int producerId) async {
    try {
      await _dio.post('/api/producer/post/toggleFollowProducer', data: {'producerId': producerId});
    } catch (e) {
      rethrow;
    }
  }
}
