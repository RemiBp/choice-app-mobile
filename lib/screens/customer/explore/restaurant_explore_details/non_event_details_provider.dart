import 'package:flutter/material.dart';
import 'package:choice_app/network/API.dart';
import 'package:choice_app/network/api_url.dart';

import '../../../../models/get_non_events_details_response.dart';

class NonEventDetailsProvider extends ChangeNotifier {
  bool isLoading = false;

  Producer? producer;
  Wellness? wellness;
  Stats? stats;
  Socials? socials;

  List<Photo> photos = [];
  List<MenuCategory> menu = [];
  List<BusinessHour> businessHours = [];

  Future<void> getNonEventDetails(String producerId) async {
    try {
      isLoading = true;
      notifyListeners();

      final url = "$getNonEventsByIdApiUrl/$producerId";

      final response = await MyApi.callGetApi(
        url: url,
        modelName: null,
      );

      if (response != null) {
        final parsed = NonEventDetailsResponse.fromJson(response);

        producer = parsed.producer;
        wellness = parsed.wellness;
        stats = parsed.stats;
        socials = parsed.socials;

        photos = producer?.photos ?? [];
        menu = producer?.menuCategory ?? [];
        businessHours = producer?.businessHours ?? [];
      }
    } catch (e) {
      debugPrint("❌ Error loading non-event details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
