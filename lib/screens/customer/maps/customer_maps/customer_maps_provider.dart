import 'package:choice_app/models/get_nearby_producers_response.dart';
import 'package:choice_app/network/API.dart';
import 'package:choice_app/network/api_url.dart';
import 'package:choice_app/network/models.dart';
import 'package:choice_app/res/loader.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:flutter/cupertino.dart';

class CustomerMapsProvider with ChangeNotifier {
  BuildContext? context;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  final Loader _loader = Loader();

  GetNearbyProducersOnMapResponse? getNearbyProducersOnMapResponse;

  Future<void> getNearbyProducers({
    required double latitude,
    required double longitude,
    required int radius,
  }) async {
    try {
      _loader.showLoader(context: context);

      // final params = {
      //   "latitude": latitude,
      //   "longitude": longitude,
      //   "radius": radius,
      // };

      //dummy
      final params = {
        "latitude": 38.703900,
        "longitude": -9.139900,
        "radius": 5,
      };

      final response = await MyApi.callGetApi(
        url: getNearbyProducersOnMapApiUrl,
        parameters: params,
        modelName: Models.getNearbyProducersOnMapModel,
      );

      debugPrint("Get nearby producers response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        getNearbyProducersOnMapResponse = response;
        debugPrint("Get nearby producers response: ${getNearbyProducersOnMapResponse?.producers?.length}");
        notifyListeners();
      } else {
        Toasts.getErrorToast(text: 'Failed to fetch nearby producers');
      }
    } catch (err) {
      debugPrint("Error getting nearby producers: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Failed to fetch nearby producers');
    }
  }
}
