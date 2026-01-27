
import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/rating_model.dart';

class PostService {
  final Dio _dio = ApiService().client;

  Future<List<PostModel>> getFeed() async {
    try {
      // debugPrint("Fetching feed with headers: ${_dio.options.headers}");
      final response = await _dio.get('/api/producer/post/getUserPosts');
      final List data = response.data['data'] ?? [];
      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getProducerMenu(int producerId) async {
    try {
      // For restaurants/wellness
      final response = await _dio.get('/api/producer/profile/getMenu', queryParameters: {'producerId': producerId});
      return response.data['menu'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await _dio.post('/api/producer/post/createUserPost', data: post.toJson());
      return PostModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveRatings(int postId, String producerType, List<RatingModel> ratings) async {
    try {
      final Map<String, double> ratingMap = {};
      for (var r in ratings) {
        ratingMap[r.criteria] = r.rating;
      }

      final payload = {
        'producerType': producerType.toLowerCase(),
        'ratings': ratingMap,
      };

      await _dio.post('/api/producer/post/saveRatings/$postId', data: payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveDishRatings(int postId, List<Map<String, dynamic>> dishRatings) async {
    try {
      final payload = {
        'postId': postId,
        'ratings': dishRatings,
      };
      await _dio.post('/api/producer/post/createDishRatings', data: payload);
    } catch (e) {
      rethrow;
    }
  }
}
