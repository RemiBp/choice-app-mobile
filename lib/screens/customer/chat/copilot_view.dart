import 'package:flutter/material.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/animations/bouncing_wrapper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../data/services/api_service.dart';
import '../home/venue_detail_view.dart';
import 'package:choice_app/appAssets/app_assets.dart';

class CopilotView extends StatefulWidget {
  const CopilotView({super.key});

  @override
  State<CopilotView> createState() => _CopilotViewState();
}

class _CopilotViewState extends State<CopilotView> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      "role": "assistant",
      "message": "Hello! I am your ChoiceApp Copilot. How can I help you discover something amazing today?",
      "data": null
    }
  ];
  bool _isTyping = false;

  Future<void> _sendMessage() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "message": query, "data": null});
      _isTyping = true;
      _controller.clear();
    });

    try {
      // Mocking the backend call to CopilotAgentService
      // In real implementation, this would use ApiService/ChatService
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/app/copilot/query"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${ApiService.token}",
        },
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({
            "role": "assistant",
            "message": data['message'],
            "data": data['data'],
            "tools": data['tools']
          });
        });
      } else {
        throw Exception("Failed to get response");
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "assistant",
          "message": "I'm having trouble connecting to my brain right now. Please try again later.",
          "data": null
        });
      });
    } finally {
      setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(text: "Choice Copilot", fontFamily: Assets.onsetSemiBold, fontSize: 18),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == "user";
                return _buildMessageBubble(msg, isUser);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8),
              child: Row(
                children: [
                  SizedBox(width: 40, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 8),
                  CustomText(text: "Copilot is thinking...", fontSize: 12, color: Colors.grey),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? AppColors.userPrimaryColor : Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isUser ? Radius.circular(16) : Radius.circular(0),
            bottomRight: isUser ? Radius.circular(0) : Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: msg['message'],
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
            if (msg['tools'] != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (msg['tools'] as List).map((tool) {
                  return ActionChip(
                    label: CustomText(text: tool.toString(), fontSize: 11, color: AppColors.userPrimaryColor),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      _controller.text = tool.toString().substring(3); // Remove emoji
                    },
                  );
                }).toList(),
              )
            ],
            if (msg['data'] != null && msg['data']['entities'] != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (msg['data']['entities'] as List).map((entity) {
                  return BouncingWrapper(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VenueDetailView(producer: entity),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.userPrimaryColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: AppColors.userPrimaryColor),
                          const SizedBox(width: 4),
                          CustomText(
                            text: "View ${entity['name']}",
                            fontSize: 12,
                            fontFamily: Assets.onsetMedium,
                            color: AppColors.userPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ask anything...",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          BouncingWrapper(
            onTap: _sendMessage,
            child: CircleAvatar(
              backgroundColor: AppColors.userPrimaryColor,
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
