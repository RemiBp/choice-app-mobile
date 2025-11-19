import 'package:choice_app/models/get_producer_booking_slots_response.dart';
import 'package:flutter/material.dart';

import '../../../../network/API.dart';
import '../../../../network/api_url.dart';
import '../../../../network/models.dart';

class CreateBookingProvider with ChangeNotifier {
  bool isLoading = false;

  Future<bool> createEventBooking({
    required int eventId,
    required int guestCount,
    String? internalNotes,
  }) async {
    isLoading = true;
    notifyListeners();

    final body = {
      "guestCount": guestCount,
      if (internalNotes != null && internalNotes.isNotEmpty)
        "internalNotes": internalNotes,
    };

    final url = "$createEventBookingApiUrl/$eventId";

    final response = await MyApi.callPostApi(
      url: url,
      body: body,
    );

    isLoading = false;
    notifyListeners();

    return response != null;
  }

  ProducerBookingSlotsResponse? slotsResponse;

  Future<void> getRestaurantSlots({
    required String userId,
    required String date,
  }) async {
    isLoading = true;
    notifyListeners();

    final response = await MyApi.callGetApi(
      url: "$getProducerBookingSlotsApiUrl/$userId",
      parameters: {
        "date": date,
        "timeZone": "Asia/Karachi",
      },
      modelName: Models.getProducerBookingSlotsModel,
    );

    if (response != null && response is ProducerBookingSlotsResponse) {
      slotsResponse = response; // already grouped
    }

    isLoading = false;
    notifyListeners();
  }



  Future<bool> createNonEventBooking({
    required int restaurantId,
    required int slotId,
    required String date,
    required int guestCount,
    String? specialRequest,
  }) async {
    isLoading = true;
    notifyListeners();

    final body = {
      "restaurantId": restaurantId,
      "slotId": slotId,
      "date": date,
      "guestCount": guestCount,
      "timeZone": "Asia/Karachi",
      if (specialRequest != null && specialRequest.isNotEmpty)
        "specialRequest": specialRequest,
    };

    final response = await MyApi.callPostApi(
      url: createNonEventBookingApiUrl,
      body: body,
    );

    isLoading = false;
    notifyListeners();

    return response != null;
  }
}
