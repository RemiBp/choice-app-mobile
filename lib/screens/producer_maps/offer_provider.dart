import 'package:choice_app/models/get_user_live_offers_response.dart';
import 'package:flutter/material.dart';
import '../../models/get_producer_offer_templates_response.dart';
import '../../network/API.dart';
import '../../network/api_url.dart';
import '../../network/models.dart';
import '../../res/toasts.dart';

class Template {
  final int? offerId;
  final String title;
  final String message;
  final int reduction;
  final int validityMinutes;
  final int maxRecipients;
  final int radiusMeters;

  Template({
    this.offerId,
    required this.title,
    required this.message,
    required this.reduction,
    required this.validityMinutes,
    required this.maxRecipients,
    required this.radiusMeters,
  });
}

class TemplateProvider with ChangeNotifier {
  final List<Template> _templates = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Template> get templates => _templates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void addTemplate(Template template) {
    _templates.add(template);
    notifyListeners();
  }

  void clearTemplates() {
    _templates.clear();
    notifyListeners();
  }

  // NEW: Send offer to backend using logged-in producer ID
  Future<bool> sendProducerOffer({
    required BuildContext context,
    required int producerId,
    required String title,
    required String message,
    required int discountPercent,
    required int validityMinutes,
    required int maxRecipients,
    required int radiusMeters,
    required bool saveAsTemplate,
    required double latitude,
    required double longitude,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final body = {
        "producerId": producerId,
        "title": title,
        "message": message,
        "discountPercent": discountPercent,
        "validityMinutes": validityMinutes,
        "maxRecipients": maxRecipients,
        "radiusMeters": radiusMeters,
        "saveAsTemplate": saveAsTemplate,
        "latitude": latitude,
        "longitude": longitude
      };

      debugPrint("📌 Offer POST Body: $body");

      final response = await MyApi.callPostApi(
        url: createProducerOfferApiUrl,
        body: body,
      );

      _isLoading = false;
      notifyListeners();

      if (response != null && response["message"] != null) {
        Toasts.getSuccessToast(text: response["message"].toString());

        // Save locally only if user checked
        if (saveAsTemplate) {
          addTemplate(Template(
            title: title,
            message: message,
            reduction: discountPercent,
            validityMinutes: validityMinutes,
            maxRecipients: maxRecipients,
            radiusMeters: radiusMeters,
          ));
        }

        return true;
      } else {
        Toasts.getErrorToast(text: "Failed to create offer");
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Offer send error: $e");
      Toasts.getErrorToast(text: "Something went wrong while creating offer");
      return false;
    }
  }

  Future<bool> getProducerOfferTemplates({
    required BuildContext context,
    required int producerId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await MyApi.callGetApi(
        url: "$baseUrl/api/producer/maps/getOfferTemplates/$producerId",
        modelName: Models.getProducerOfferTemplateModel, // already registered
      );

      _isLoading = false;
      notifyListeners();

      // Type-safe parse
      if (response is GetProducerOfferTemplatesResponse) {
        debugPrint("✅ Producer Offer Templates fetched: ${response.message}");

        if (response.data.isNotEmpty) {
          for (var item in response.data) {
            addTemplate(
              Template(
                offerId: item.id,
                title: item.title,
                message: item.message,
                reduction: item.discountPercent,
                validityMinutes: item.validityMinutes,
                maxRecipients: item.maxRecipients,
                radiusMeters: item.radiusMeters,
              ),
            );
          }

          Toasts.getSuccessToast(text: response.message);
          return true;
        } else {
          Toasts.getErrorToast(text: "No offer templates found.");
          return false;
        }
      } else {
        Toasts.getErrorToast(text: "Failed to parse offer templates.");
        return false;
      }

    } catch (e) {
      _isLoading = false;
      _errorMessage = "Error fetching templates";
      notifyListeners();
      debugPrint("❌ getProducerOfferTemplates error: $e");
      Toasts.getErrorToast(text: "Something went wrong while fetching templates.");
      return false;
    }
  }

  Future<bool> editProducerOffer({
    required BuildContext context,
    required int offerId,
    required String title,
    required String message,
    required int discountPercent,
    required int validityMinutes,
    required int maxRecipients,
    required int radiusMeters,
    required bool saveAsTemplate,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final body = {
        "title": title,
        "message": message,
        "discountPercent": discountPercent,
        "validityMinutes": validityMinutes,
        "maxRecipients": maxRecipients,
        "radiusMeters": radiusMeters,
        "saveAsTemplate": saveAsTemplate,
      };

      debugPrint("📌 Edit Offer Body: $body");

      final response = await MyApi.callPutApi(
        url: "$editProducerOfferApiUrl/$offerId",
        body: body,
      );

      _isLoading = false;
      notifyListeners();

      if (response != null && response["message"] != null) {
        Toasts.getSuccessToast(text: response["message"].toString());
        return true;
      } else {
        Toasts.getErrorToast(text: "Failed to update offer");
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("❌ Edit offer error: $e");
      Toasts.getErrorToast(text: "Something went wrong while updating offer");
      return false;
    }
  }

  Future<GetUserLiveOffersResponse?> getUserLiveOffers({
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await MyApi.callGetApi(
        url: getUserLiveOfferApiUrl,
        modelName: Models.getUserLiveOfferModel,
      );

      _isLoading = false;
      notifyListeners();

      if (response is GetUserLiveOffersResponse) {
        debugPrint("✅ User Live Offers fetched: ${response.message}");
        return response; // return the full response object
      } else {
        Toasts.getErrorToast(text: "Failed to parse live offers.");
        return null;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Error fetching live offers";
      notifyListeners();
      debugPrint("❌ getUserLiveOffers error: $e");
      Toasts.getErrorToast(text: "Something went wrong while fetching live offers.");
      return null;
    }
  }



}
