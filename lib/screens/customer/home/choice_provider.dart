import 'package:choice_app/models/get_producer_places.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l18n.dart';
import '../../../network/API.dart';
import '../../../network/api_url.dart';
import '../../../network/models.dart';
import '../../../res/loader.dart';
import '../../../res/toasts.dart';

class CustomerChoiceProvider extends ChangeNotifier {
  ProducerPlacesResponse placesResponse = ProducerPlacesResponse();
  BuildContext? context;

  final Loader _loader = Loader();

  init(context) {
    this.context = context;
  }

  Future<void> getProducerPlaces(String producerType,{String? query}) async {
    try {
      if (query == null || query.isEmpty) {
        _loader.showLoader(context: context);
      }
      final Map<String, dynamic> parameters = {"type": producerType};
      if (query != null && query.isNotEmpty) {
        parameters["query"] = query;
      }

      placesResponse = await MyApi.callGetApi(
        url: getProducerPlacesApiUrl,
        modelName: Models.producerPlacesModel,
        parameters: parameters,
      );

      debugPrint("Get Producer Places response: ${placesResponse.status}");

      if (query == null || query.isEmpty) {
        _loader.hideLoader(context!);
      }


      if (placesResponse.data == null) {
        Toasts.getErrorToast(text: al.failedToFetchPlaces);
      }
      notifyListeners();
    } catch (err) {
      debugPrint("Error getting Producers: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToFetchPlaces);
    }
  }

  Future<void> createChoice({
    required String producerType,
    required int placeId,
    required String status,
    required String description,
    required List<String> tags,
    required List<String> imageUrls,
    required Map<String, dynamic> rating,
  }) async {
    try {
      _loader.showLoader(context: context);
      Map<String, dynamic> headers = {"Content-Type": "application/json"};
      Map<String, dynamic> body = {
        "placeId": placeId,
        "type": producerType,
        "status": status,
        "title": "Sample",
        "description": description,
        "link": "https://yourrestaurant.com/sunday-brunch",
        "tags": tags,
        "imageUrls": imageUrls,
        "coverImage": imageUrls[0],
        "publishDate": DateTime.now().toUtc().toIso8601String(),
        "createdBy": "api-user-123",
        "location": "abc, xyz",
      };
      debugPrint("body is : ---------->$body");

      final response = await MyApi.callPostApi(
        url: createUserPostApiUrl,
        myHeaders: headers,
        body: body,
      );

      debugPrint("choice response : $response");

      if (response != null) {
        Toasts.getSuccessToast(text: response?["message"]);

        // 🚫 Do NOT show loader again in saveRating
        await saveRating(
          choiceId: response["data"]["id"],
          userRating: rating,
          producerType: producerType,
          showLoader: false, // add this flag
        );
      }

      _loader.hideLoader(context!);
    } catch (err) {
      debugPrint("error during saving rating : $err");
      _loader.hideLoader(context!);
    }
  }


  Future<void> saveRating({
    required int choiceId,
    required String producerType,
    required Map<String, dynamic> userRating,
    bool showLoader = true, // new param
  }) async {
    try {
      if (showLoader) _loader.showLoader(context: context);

      final generalRating = userRating["general"];
      final rating = producerType == "restaurant"
          ? {
        "service": generalRating["Service"],
        "place": generalRating["Place"],
        "portions": generalRating["Portions"],
        "ambiance": generalRating["Ambiance"],
      }
          : producerType == "leisure"
          ? {
        "stageDirection": generalRating["Stage Direction"],
        "actorPerformance": generalRating["Actor Performance"],
        "textQuality": generalRating["Text Quality"],
        "scenography": generalRating["Scenography"],
      }
          : {
        "careQuality": generalRating["Care Quality"],
        "cleanliness": generalRating["Cleanliness"],
        "welcome": generalRating["Welcome"],
        "valueForMoney": generalRating["Value For Money"],
        "atmosphere": generalRating["Atmosphere"],
        "staffExperience": generalRating["Staff Experience"]
      };

      Map<String, dynamic> headers = {"Content-Type": "application/json"};
      Map<String, dynamic> body = {
        "producerType": producerType,
        "ratings": rating,
        "comment": "test sample comment",
      };

      debugPrint("body is : ---------->$body");

      final response = await MyApi.callPostApi(
        url: "$saveResRatingApiUrl/$choiceId",
        myHeaders: headers,
        body: body,
      );

      debugPrint("save rating response : $response");

      if (response != null) {
        Toasts.getSuccessToast(text: response?["message"]);
        await Future.delayed(const Duration(milliseconds: 200)); // 👈 small pause

        context?.pop();
      }

      if (showLoader) _loader.hideLoader(context!);
    } catch (err) {
      debugPrint("error during saving rating : $err");
      if (showLoader) _loader.hideLoader(context!);
    }
  }

}
