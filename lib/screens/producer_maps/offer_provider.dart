import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../network/API.dart';
import '../../network/api_url.dart';
import '../../res/res.dart';
import '../../res/toasts.dart';
import '../restaurant/profile/profile_provider.dart';

class Template {
  final String title;
  final String message;
  final int reduction;

  Template({
    required this.title,
    required this.message,
    required this.reduction,
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

        // ✅ Save locally only if user checked
        if (saveAsTemplate) {
          addTemplate(Template(
            title: title,
            message: message,
            reduction: discountPercent,
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

}
