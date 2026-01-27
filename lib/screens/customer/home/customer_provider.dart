
import 'package:flutter/material.dart';
import '../../../data/services/customer_service.dart';
import '../../../data/services/map_service.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerService _service = CustomerService();
  final MapService _mapService = MapService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<dynamic> _feedConfig = [];
  List<dynamic> get feed => _feedConfig;

  List<dynamic> _nearbyVenues = [];
  List<dynamic> get nearbyVenues => _nearbyVenues;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFeed() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _feedConfig = await _service.getUserFeed();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error fetching feed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchVenues({required double lat, required double lng, String type = 'ALL'}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _mapService.getNearbyProducers(latitude: lat, longitude: lng, type: type);
      _nearbyVenues = response.data['data'] ?? [];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
