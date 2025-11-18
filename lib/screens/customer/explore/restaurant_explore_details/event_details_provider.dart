import 'package:flutter/material.dart';
import 'package:choice_app/network/API.dart';
import 'package:choice_app/network/api_url.dart';
import 'package:choice_app/models/get_events_details_response.dart';

import '../../../../models/more_events_by_producer_response.dart';

class EventDetailsProvider extends ChangeNotifier {
  bool isLoading = false;

  EventData? eventData;
  Map<String, dynamic>? rawResponse;
  bool _hasFetchedMoreEvents = false;


  bool isMoreEventsLoading = false;
  Data? moreEventsData;              // Contains producerId, type, totalEvents
  List<Event>? moreEventsList = [];


  Future<void> getEventById(int eventId) async {
    try {
      isLoading = true;
      notifyListeners();

      _hasFetchedMoreEvents = false; //  Reset
      moreEventsList = [];           //  Reset list

      final url = "$getEventsByIdApiUrl/$eventId";

      final response = await MyApi.callGetApi(url: url, modelName: null);

      if (response != null) {
        rawResponse = response;
        final parsed = EventDetailsResponse.fromJson(response);
        eventData = parsed.data;

        if (eventData?.producer?.id != null) {
          getEventsByProducer(eventData!.producer!.id!);
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching event details: $e");
      eventData = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getEventsByProducer(int producerId) async {
    if (_hasFetchedMoreEvents) return; //  Prevent duplicate calls
    _hasFetchedMoreEvents = true;

    try {
      isMoreEventsLoading = true;
      notifyListeners();

      final url = "$getEventsByProducerApiUrl/$producerId";

      final response = await MyApi.callGetApi(
        url: url,
        modelName: null,
      );

      if (response != null) {
        final parsed = MoreEventsByProducerResponse.fromJson(response);

        moreEventsData = parsed.data;
        moreEventsList = parsed.data?.events ?? [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching producer events: $e");
      moreEventsList = [];
      moreEventsData = null;
    } finally {
      isMoreEventsLoading = false;
      notifyListeners();
    }
  }
}
