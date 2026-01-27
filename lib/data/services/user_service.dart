
import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = ApiService().client;

  Future<List<dynamic>> getMyFriends() async {
    try {
      final response = await _dio.get('/api/app/profile/getMyFollowers');
      // Backend returns a list of objects with { id, name, email, profileImage }
      return response.data ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> searchUsers(String query) async {
    try {
      final response = await _dio.get('/api/app/profile/searchUsers', queryParameters: {'query': query});
      return response.data ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
