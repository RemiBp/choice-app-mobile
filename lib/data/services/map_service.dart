import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class MapService {
  final ApiService _apiService = ApiService();

  Future<Response> getProducerHeatmap(int producerId) async {
    return await _apiService.client.get('/api/producer/maps/getProducerHeatmap/$producerId');
  }

  Future<Response> getNearbyProducers({
    required double latitude,
    required double longitude,
    double radius = 5,
    String type = 'ALL',
  }) async {
    return await _apiService.client.get(
      '/api/app/maps/getNearbyProducers',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'type': type,
      },
    );
  }

  Future<Response> getNearbyUsers({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    return await _apiService.client.get(
      '/api/producer/maps/getNearbyUsers',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      },
    );
  }

  Future<Response> getOfferTemplates(int producerId) async {
    return await _apiService.client.get('/api/producer/maps/getOfferTemplates/$producerId');
  }

  Future<Response> createProducerOffer(Map<String, dynamic> data) async {
    return await _apiService.client.post('/api/producer/maps/createProducerOffer', data: data);
  }

  Future<Response> sendOfferNotification(Map<String, dynamic> data) async {
    return await _apiService.client.post('/api/producer/maps/sendOfferNotification', data: data);
  }

  // Catalog Fetching
  Future<Response> getMenu() async {
    return await _apiService.client.get('/api/producer/profile/getMenu');
  }

  Future<Response> getWellnessServices() async {
    return await _apiService.client.get('/api/producer/service/getAllServices');
  }

  Future<Response> getLeisureEvents() async {
    return await _apiService.client.get('/api/producer/event/getMyEvents');
  }
}
