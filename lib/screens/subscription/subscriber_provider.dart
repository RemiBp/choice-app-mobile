import 'package:flutter/material.dart';
import '../../network/API.dart';
import '../../network/api_url.dart';
import '../../res/toasts.dart';

class CopilotMessage {
  final String text;
  final bool isUser;
  final dynamic data;

  CopilotMessage({
    required this.text,
    required this.isUser,
    this.data,
  });
}

class SubscriberProvider extends ChangeNotifier {
  bool isLoading = false;
  List<CopilotMessage> messages = [];
  bool limitBlocked = false;

  int remaining = 20;
  String? plan;

  VoidCallback? onLimitReached;

  Future<void> sendQuery(String query) async {
    if (query.trim().isEmpty) return;

    if (limitBlocked) {
      // Trigger dialog when already blocked
      onLimitReached?.call();
      return;
    }

    if (remaining == 0) {
      limitBlocked = true;
      notifyListeners();
      onLimitReached?.call(); // Trigger dialog
      return;
    }

    // Add user message
    messages.add(CopilotMessage(text: query, isUser: true));
    notifyListeners();

    isLoading = true;
    notifyListeners();

    try {
      final response = await MyApi.callPostApi(
        url: copilotQueryApiUrl,
        body: {"query": query},
      );

      final result = response["result"];

      // Check result message for limit (not response message!)
      if (result != null && result["message"] != null &&
          result["message"].toString().contains("free Copilot query limit")) {

        limitBlocked = true;
        remaining = 0;

        // Remove the last user message since it wasn't processed
        if (messages.isNotEmpty && messages.last.isUser) {
          messages.removeLast();
        }

        notifyListeners();

        // Trigger the dialog
        onLimitReached?.call();

        isLoading = false;
        notifyListeners();
        return;
      }

      // Update remaining and plan from result data
      if (result["data"] != null) {
        remaining = result["data"]["remaining"] ?? remaining;
        plan = result["data"]["plan"] ?? plan;
      }

      if (remaining == 0) {
        limitBlocked = true;
      }

      messages.add(
        CopilotMessage(
          text: result["message"] ?? "",
          isUser: false,
          data: result["data"],
        ),
      );

    } catch (e) {
      Toasts.getErrorToast(text: "Failed to process your query");
    }

    isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    messages.clear();
    notifyListeners();
  }
}