import 'package:choice_app/data/services/chat_service.dart';
import 'package:choice_app/common/utils.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();
  
  List<dynamic> _chats = [];
  List<dynamic> get chats => _chats;

  List<dynamic> _currentMessages = [];
  List<dynamic> get currentMessages => _currentMessages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void init(String token) {
    _service.initSocket(token);
    _setupListeners();
    fetchChats();
  }

  void _setupListeners() {
    _service.onChatsLoaded((data) {
      _chats = data ?? [];
      _isLoading = false;
      notifyListeners();
    });

    _service.onMessagesLoaded((data) {
      _currentMessages = data ?? []; // TODO: Handle pagination append
      _isLoading = false;
      notifyListeners();
    });

    _service.onMessageReceived((data) {
      // If belongs to current chat
      // Check chatId
      // For now just append
      _currentMessages.add(data);
      notifyListeners();
      // Also update chat list preview if needed
    });
    
    _service.onMessageSent((data) {
       _currentMessages.add(data);
       notifyListeners();
    });
  }

  void fetchChats() {
    _isLoading = true;
    // notifyListeners(); // Avoid flicker
    _service.getChats();
  }

  void fetchMessages(int chatId) {
    _isLoading = true;
    _currentMessages = []; // Clear previous
    notifyListeners();
    _service.getMessages(chatId, 1, 50);
  }

  void sendMessage(int chatId, String content) {
    _service.sendMessage({
      'chatId': chatId,
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}
