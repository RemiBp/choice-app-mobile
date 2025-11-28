import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:choice_app/res/toasts.dart';
import '../../models/get_producer_heatmap_response.dart';
import '../../network/API.dart';
import '../../network/api_url.dart';
import '../restaurant/profile/profile_provider.dart';

class ProducerHeatmapProvider with ChangeNotifier {
  BuildContext? context;
  bool _isLoading = false;
  String? _errorMessage;
  List<GetProducerHeatmapResponse> _heatmapPoints = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<GetProducerHeatmapResponse> get heatmapPoints => _heatmapPoints;

  // Convert points to map for Google Maps circles
  List<Map<String, dynamic>> get heatmapCoordinates => _heatmapPoints
      .map((e) => {
    "lat": e.lat,
    "lng": e.lng,
    "count": e.count,
  })
      .toList();

  // Fetch heatmap from API
  Future<bool> fetchProducerHeatmapFromProfile() async {
    if (context == null) {
      _errorMessage = "Context is null";
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get ProfileProvider
      final profileProvider =
      Provider.of<ProfileProvider>(context!, listen: false);

      // Wait for profile to load if not already
      final producerResponse = await profileProvider.getProducerProfile();

      // Check if profile loaded successfully
      if (producerResponse == null) {
        _isLoading = false;
        _errorMessage = "Failed to load producer profile";
        debugPrint("Error: getProducerProfile returned null");
        notifyListeners();
        Toasts.getErrorToast(text: _errorMessage ?? "Unknown error");
        return false;
      }

      // Safely extract producer ID with null checks
      final producer = producerResponse.producer;

      if (producer == null) {
        _isLoading = false;
        _errorMessage = "Producer data is missing";
        debugPrint("Error getting producer profile: Producer is null");
        notifyListeners();
        Toasts.getErrorToast(text: _errorMessage ?? "Unknown error");
        return false;
      }

      final producerId = producer.id;

      if (producerId == null) {
        _isLoading = false;
        _errorMessage = "Producer ID is missing";
        debugPrint("Error getting producer profile: Producer ID is null");
        notifyListeners();
        Toasts.getErrorToast(text: _errorMessage ?? "Unknown error");
        return false;
      }

      // Build API URL
      final heatmapUrl =
      getProducerHeatmapApiUrl.replaceAll("{id}", producerId.toString());

      debugPrint("Fetching heatmap from: $heatmapUrl");

      final response = await MyApi.callGetApi(url: heatmapUrl);

      debugPrint("Heatmap API Response: $response");

      if (response == null) {
        _isLoading = false;
        _errorMessage = "No response from server";
        notifyListeners();
        Toasts.getErrorToast(text: _errorMessage ?? "Unknown error");
        return false;
      }

      if (response["status"] == 200 && response["data"] != null) {
        final data = response["data"];

        if (data is List) {
          _heatmapPoints = data
              .map((e) => GetProducerHeatmapResponse.fromJson(e))
              .toList();

          debugPrint("Successfully loaded ${_heatmapPoints.length} heatmap points");

          //  If API returned empty fallback to dummy
          if (_heatmapPoints.isEmpty) {
            debugPrint("⚠️ API returned EMPTY heatmap → using DUMMY DATA");
            _heatmapPoints = _dummyHeatmapData();
          }
        } else {
          debugPrint("⚠️ API returned invalid format → using DUMMY DATA");
          _heatmapPoints = _dummyHeatmapData();
        }


        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response["message"] ?? "Failed to fetch heatmap";
        _isLoading = false;
        notifyListeners();
        Toasts.getErrorToast(text: _errorMessage ?? "Unknown error");
        return false;
      }
    } catch (err, stackTrace) {
      _isLoading = false;
      _errorMessage = "Error: $err";
      debugPrint("Heatmap API Error: $err");
      debugPrint("Stack trace: $stackTrace");
      notifyListeners();
      Toasts.getErrorToast(text: "Error: ${err.toString()}");
      return false;
    }
  }

  // Clear heatmap points
  void clearHeatmap() {
    _heatmapPoints = [];
    _errorMessage = null;
    notifyListeners();
  }

  List<GetProducerHeatmapResponse> _dummyHeatmapData() {
    return [
      GetProducerHeatmapResponse(lat: 31.5200, lng: 74.3580, count: 5, users: []),
      GetProducerHeatmapResponse(lat: 31.5205, lng: 74.3585, count: 10, users: []),
      GetProducerHeatmapResponse(lat: 31.5210, lng: 74.3590, count: 20, users: []),
      GetProducerHeatmapResponse(lat: 31.5215, lng: 74.3595, count: 8, users: []),
      GetProducerHeatmapResponse(lat: 31.5220, lng: 74.3600, count: 15, users: []),

      // Additional points for better heatmap spread
      GetProducerHeatmapResponse(lat: 31.5195, lng: 74.3575, count: 12, users: []),
      GetProducerHeatmapResponse(lat: 31.5225, lng: 74.3605, count: 18, users: []),
      GetProducerHeatmapResponse(lat: 31.5198, lng: 74.3592, count: 7, users: []),
    ];
  }

  // Helper to get provider instance
  static ProducerHeatmapProvider of(BuildContext context,
      {bool listen = false}) {
    return Provider.of<ProducerHeatmapProvider>(context, listen: listen);
  }
}