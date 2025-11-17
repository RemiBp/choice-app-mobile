import 'package:flutter/material.dart';

import '../../../../network/API.dart';
import '../../../../network/api_url.dart';

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
}
