import 'package:choice_app/models/chat_model.dart';
import 'package:choice_app/network/socket_service.dart';
import 'package:flutter/material.dart';

class MessagesProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  int? _currentChatId;
  List<Message> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMoreMessages = true;
  final int _limit = 20;

  int? get currentChatId => _currentChatId;
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get error => _error;
  bool get hasMoreMessages => _hasMoreMessages;

  void init(BuildContext context, int chatId) {
    _currentChatId = chatId;
    _messages = [];
    _currentPage = 1;
    _hasMoreMessages = true;
    _setupSocketListeners();
    loadMessages();
  }

  /// Setup socket event listeners
  void _setupSocketListeners() {
    _socketService.setOnMessagesReceived(_handleMessagesReceived);
    _socketService.setOnMessageSent(_handleMessageSent);
    _socketService.setOnMessageReceived(_handleMessageReceived);
    _socketService.setOnError(_handleError);
  }

  /// Load messages for current chat
  void loadMessages({int? page}) {
    if (_currentChatId == null) {
      debugPrint('⚠️ Cannot load messages: No chat ID set');
      return;
    }

    if (!_socketService.isConnected) {
      debugPrint('⚠️ Cannot load messages: Socket not connected');
      _error = 'Connection not available';
      notifyListeners();
      return;
    }

    final targetPage = page ?? _currentPage;
    _isLoading = true;
    _error = null;
    notifyListeners();

    _socketService.emitGetMessages(
      chatId: _currentChatId!,
      page: targetPage,
      limit: _limit,
    );
  }

  /// Handle messages received from server
  void _handleMessagesReceived(dynamic data) {
    try {
      debugPrint('💬 Handling messages received: ${data.runtimeType}');

      if (data is List) {
        debugPrint('💬 Parsing ${data.length} messages...');
        final newMessages =
            data.map((msgJson) {
              final message = Message.fromJson(msgJson);
              debugPrint(
                '  📝 Message ${message.id}: senderId=${message.senderId}, content="${message.content}"',
              );
              return message;
            }).toList();

        if (_currentPage == 1) {
          _messages = newMessages;
        } else {
          _messages.insertAll(0, newMessages);
        }
        _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        _hasMoreMessages = newMessages.length >= _limit;

        debugPrint(
          '✅ Loaded ${newMessages.length} messages (page: $_currentPage)',
        );
      } else {
        debugPrint('⚠️ Unexpected data type for messages: ${data.runtimeType}');
      }

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error parsing messages: $e');
      _error = 'Failed to load messages';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send a new message
  void sendMessage({
    required String content,
    String? fileUrl,
    String messageType = 'text',
  }) {
    if (_currentChatId == null) {
      debugPrint('⚠️ Cannot send message: No chat ID set');
      return;
    }

    if (!_socketService.isConnected) {
      debugPrint('⚠️ Cannot send message: Socket not connected');
      _error = 'Connection not available';
      notifyListeners();
      return;
    }

    if (content.trim().isEmpty && fileUrl == null) {
      debugPrint('⚠️ Cannot send empty message');
      return;
    }

    _isSending = true;
    _error = null;
    notifyListeners();

    _socketService.emitNewMessage(
      chatId: _currentChatId!,
      content: content,
      fileUrl: fileUrl,
      messageType: messageType,
    );
  }

  /// Handle message sent confirmation
  void _handleMessageSent(dynamic data) {
    try {
      debugPrint('📤 Handling message sent: $data');

      if (data is Map<String, dynamic>) {
        final message = Message.fromJson(data);

        if (message.chatId == _currentChatId) {
          _addMessageToList(message);
        }
      }

      _isSending = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error handling message sent: $e');
      _isSending = false;
      _error = 'Failed to send message';
      notifyListeners();
    }
  }

  /// Handle new message received from another user
  void _handleMessageReceived(dynamic data) {
    try {
      debugPrint('📥 Handling message received: $data');

      if (data is Map<String, dynamic>) {
        final message = Message.fromJson(data);

        if (message.chatId == _currentChatId) {
          _addMessageToList(message);
        }
      }
    } catch (e) {
      debugPrint('❌ Error handling message received: $e');
    }
  }

  /// Add message to list (avoiding duplicates)
  void _addMessageToList(Message message) {
    // Check if message already exists
    final existingIndex = _messages.indexWhere((m) => m.id == message.id);

    if (existingIndex == -1) {
      // Message doesn't exist, add it
      _messages.add(message);
      debugPrint('✅ Added message ${message.id} to list');
      notifyListeners();
    } else {
      debugPrint('ℹ️ Message ${message.id} already exists in list');
    }
  }

  /// Handle socket errors
  void _handleError(String error) {
    debugPrint('❌ Messages Provider: Socket error: $error');
    _error = error;
    _isLoading = false;
    _isSending = false;
    notifyListeners();
  }

  /// Load more messages (pagination)
  void loadMoreMessages() {
    if (_isLoading || !_hasMoreMessages) {
      return;
    }

    _currentPage++;
    loadMessages(page: _currentPage);
  }

  /// Reset provider state
  void reset() {
    _currentChatId = null;
    _messages = [];
    _currentPage = 1;
    _hasMoreMessages = true;
    _isLoading = false;
    _isSending = false;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _socketService.setOnMessagesReceived((_) {});
    _socketService.setOnMessageSent((_) {});
    _socketService.setOnMessageReceived((_) {});
    super.dispose();
  }
}
