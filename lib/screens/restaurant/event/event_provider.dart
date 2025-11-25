import 'package:choice_app/models/get_all_events_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/event_type_model.dart';
import '../../../network/API.dart';
import '../../../network/api_url.dart';
import '../../../network/models.dart';
import '../../../res/loader.dart';
import '../../../res/toasts.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';

enum EventStatus { Active, Draft, Closed }

class EventProvider extends ChangeNotifier {
  GetAllEventsResponse getAllEventsResponse = GetAllEventsResponse();
  GetAllEventsResponse getDraftEventsResponse = GetAllEventsResponse();
  GetAllEventsResponse getCompletedEventsResponse = GetAllEventsResponse();

  final Loader _loader = Loader();

  BuildContext? context;

  init(context) {
    this.context = context;
    getAllEvents();
    getDraftEvents();
    getCompletedEvents();
  }

  Future<void> createEventApi({
    required String eventName,
    required String description,
    required String venue,
    required String address,
    required String capacity,
    required String price,
    required String date,
    required String startTime,
    required String endTime,
    required List<String> images,
    int? eventTypeId, // only used for leisure
    double? latitude,
    double? longitude,
    String? timeZone,
  }) async {
    try {
      _loader.showLoader(context: context);

      final roleProvider = context!.read<RoleProvider>();

      String serviceType =
          roleProvider.role == UserRole.restaurant ? "Restaurant" : "Leisure";

      final body = {
        "title": eventName,
        "description": description,
        "serviceType": serviceType,
        "location": address,
        "pricePerGuest": double.tryParse(price) ?? 0,
        "maxCapacity": int.tryParse(capacity) ?? 0,
        "status": "Active",
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "eventImages": images,
        "latitude": latitude ?? "0.0", // fallback if null
        "longitude": longitude ?? "0.0",
        "timeZone": timeZone ?? "Asia/Karachi", // fallback timezone
      };

      if (serviceType == "Restaurant") {
        body["venueName"] = venue;
      } else if (serviceType == "Leisure" && eventTypeId != null) {
        body["eventTypeId"] = eventTypeId;
      }

      debugPrint("body for create post is : $body");

      final response = await MyApi.callPostApi(
        url: createEventPostApiUrl,
        body: body,
      );

      _loader.hideLoader(context!);

      if (response?["message"] != null) {
        Toasts.getSuccessToast(text: response?["message"]);
      }
    } catch (err) {
      _loader.hideLoader(context!);
      debugPrint("error while creating event is : $err");
    }
  }

  Future<void> getAllEvents() async {
    try {
      _loader.showLoader(context: context);
      getAllEventsResponse = await MyApi.callGetApi(
        url: getAllEventsApiUrl,
        parameters: {"status": EventStatus.Active.name},
        modelName: Models.eventsModel,
      );
      debugPrint("response is : ${getAllEventsResponse.data?.length}");
      _loader.hideLoader(context!);
      notifyListeners();
    } catch (err) {
      debugPrint("error while getting all events : $err");
      _loader.hideLoader(context!);
      notifyListeners();
    }
  }

  Future<void> getDraftEvents() async {
    try {
      _loader.showLoader(context: context);
      getDraftEventsResponse = await MyApi.callGetApi(
        url: getAllEventsApiUrl,
        parameters: {"status": EventStatus.Draft.name},
        modelName: Models.eventsModel,
      );
      debugPrint("response is : ${getDraftEventsResponse.data?.length}");
      _loader.hideLoader(context!);
      notifyListeners();
    } catch (err) {
      debugPrint("error while getting draft events : $err");
      _loader.hideLoader(context!);
      notifyListeners();
    }
  }

  Future<void> getCompletedEvents() async {
    try {
      _loader.showLoader(context: context);
      getCompletedEventsResponse = await MyApi.callGetApi(
        url: getAllEventsApiUrl,
        parameters: {"status": EventStatus.Closed.name},
        modelName: Models.eventsModel,
      );
      debugPrint("response is : ${getCompletedEventsResponse.data?.length}");
      _loader.hideLoader(context!);
      notifyListeners();
    } catch (err) {
      debugPrint("error while getting completed events : $err");
      _loader.hideLoader(context!);
      notifyListeners();
    }
  }

  Future<void> deleteEvent({required int eventId, required bool isActiveEvent}) async {
    try {
      _loader.showLoader(context: context);
      await MyApi.callDeleteApi(
        url: '$deleteEventApiUrl$eventId',
      );
      _loader.hideLoader(context!);
      Navigator.pop(context!);
      Toasts.getSuccessToast(text: 'Event deleted successfully');
      if(isActiveEvent) {
        getAllEvents();
      } else {
        getDraftEvents();
      }
    } catch (err) {
      debugPrint("error in deleting event : $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: err.toString());
    }
  }

  List<EventTypeModel> eventTypesList = [];

  Future<void> getEventTypes() async {
    try {
      final response = await MyApi.callGetApi(
        url: getEventsTypeApiUrl,
        modelName: Models.getEventsTypeModel,
      );

      if (response != null) {
        eventTypesList =
            response.data
                .map<EventTypeModel>((e) => EventTypeModel.fromJson(e.toJson()))
                .toList();
        notifyListeners();
      }
    } catch (err) {
      debugPrint("Error fetching event types: $err");
    }
  }
}
