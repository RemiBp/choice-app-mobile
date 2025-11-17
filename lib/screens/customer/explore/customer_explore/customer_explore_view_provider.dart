import 'package:choice_app/network/api_url.dart';
import 'package:flutter/material.dart';

import '../../../../common/utils.dart';
import '../../../../models/get_all_events_near_me_response.dart';
import '../../../../models/near_by_producers_response.dart';
import '../../../../network/API.dart';
import '../../../../network/models.dart';


class ExploreViewProvider extends ChangeNotifier {
  final BuildContext context;

  ExploreViewProvider({required this.context});

  bool isLoading = false;
  bool isEventsLoading = false;
  bool isProducersLoading = false;
  List<EventData> events = [];

  Future<void> getEventsNearMe() async {
    try {
      isEventsLoading = true;
      notifyListeners();

      //  Read lat/lng saved from profile
      final latString = PreferenceUtils.getString("latitude");
      final lngString = PreferenceUtils.getString("longitude");

      double lat = double.tryParse(latString ?? "") ?? 38.716900;
      double lng = double.tryParse(lngString ?? "") ?? -9.139000;

      final url = "$getEventsNearMeApiUrl?lat=$lat&lng=$lng&radius=1000000000000";

      debugPrint("📍 Calling GET: $url");

      final response = await MyApi.callGetApi(
        url: url,
        modelName: Models.getEventsNearMeModel,
      );

      if (response != null && response.data != null) {
        events = response.data!
            .where((e) =>
        e.serviceType?.toLowerCase() == 'restaurant' ||
            e.serviceType?.toLowerCase() == 'leisure')
            .toList();
      }

      isEventsLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching events near me: $e");
      isEventsLoading = false;
      notifyListeners();
    }
  }

  Future<NearbyProducersResponse?> findNearbyProducers({
    required double latitude,
    required double longitude,
    String? keyword,
    int? radius,
    int? page,
    int? limit,
    String? producerType,
  }) async {
    final body = {
      "latitude": latitude,
      "longitude": longitude,
      "keyword": keyword ?? "",
      "radius": radius ?? 10000,
      "page": page ?? 1,
      "limit": limit ?? 10,
    };

    if (producerType != null && producerType.isNotEmpty) {
      body["producerType"] = producerType;
    }

    final response = await MyApi.callPostApi(
      url: nearByProducersApiUrl,
      body: body,
    );

    if (response != null) {
      return NearbyProducersResponse.fromJson(response);
    }
    return null;
  }

  List<ProducerItem> nearbyProducers = [];

  Future<void> getNearbyProducers({
    List<String>? allowedTypes,  // for Surprise Me
    String? producerType,       // for category-specific fetch
  }) async {
    try {
      isProducersLoading = true;
      notifyListeners();

      String? typeForApi;
      if (producerType != null) {
        typeForApi = producerType.toLowerCase();
      }

      // Hardcoded lat, long and radius for now
      final response = await findNearbyProducers(
        latitude: 31.470404754490897,
        longitude: 74.38929248891314,
        radius: 120000000000000000,
        keyword: "",
        producerType: typeForApi, // pass single category if provided
      );
      var producers = response?.data?.producers ?? [];

      // If allowedTypes is provided (Surprise Me), filter locally
      if (allowedTypes != null && allowedTypes.isNotEmpty) {
        producers = producers
            .where((p) =>
        p.type != null &&
            allowedTypes.contains(p.type!.toLowerCase()))
            .toList();
      }

      nearbyProducers = producers;

    } catch (e) {
      debugPrint("Error fetching nearby producers: $e");
      nearbyProducers = [];
    } finally {
      isProducersLoading = false;
      notifyListeners();
    }
  }


}
