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
      if (result != null) {
        remaining = result["remaining"] ?? remaining;
        plan = result["plan"] ?? plan;
      }

      if (remaining == 0) {
        limitBlocked = true;
      }

      String formatted = _formatCopilotData(result["data"]);

      messages.add(
        CopilotMessage(
          text: formatted,
          isUser: false,
        ),
      );

    } catch (e) {
      Toasts.getErrorToast(text: "Failed to process your query");
    }

    isLoading = false;
    notifyListeners();
  }
  String _formatCopilotData(dynamic data) {
    if (data == null || data is! List) return "";

    final ignoreKeys = {"id", "latitude", "longitude", "distance_km"};

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      buffer.writeln("• *Item ${i + 1}:*");

      item.forEach((key, value) {
        if (!ignoreKeys.contains(key) &&
            value != null &&
            value.toString().trim().isNotEmpty) {

          buffer.writeln("   - ${_formatKey(key)}: $value");
        }
      });

      buffer.writeln(""); // blank line between items
    }

    return buffer.toString().trim();
  }

  String _formatKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m.group(1)} ${m.group(2)}')
        .replaceAll("_", " ")
        .replaceFirst(key[0], key[0].toUpperCase());
  }

  void clearChat() {
    messages.clear();
    notifyListeners();
  }
}