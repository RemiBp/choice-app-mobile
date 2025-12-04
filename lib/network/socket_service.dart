import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;

  Function(dynamic)? _onChatsReceived;
  Function(dynamic)? _onMessagesReceived;
  Function(dynamic)? _onChatCreated;
  Function(dynamic)? _onMessageSent;
  Function(dynamic)? _onMessageReceived;
  Function(String)? _onError;
  Function()? _onConnected;
  Function()? _onDisconnected;

  IO.Socket? get socket => _socket;
  bool get isConnected => _isConnected;

  void connect(String jwtToken) {
    if (_socket != null && _socket!.connected) {
      debugPrint('🟢 Socket already connected');
      return;
    }

    debugPrint('🔵 Connecting to socket...');

    _socket = IO.io(
      'http://choice-app-prod-env.eba-wqrm9be2.eu-west-3.elasticbeanstalk.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({'token': jwtToken})
          .build(),
    );

    _registerBaseListeners();
  }

  /// Disconnect from socket
  void disconnect() {
    debugPrint('🔴 Disconnecting socket...');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _clearCallbacks();
  }

  /// Register base socket listeners
  void _registerBaseListeners() {
    _socket?.onConnect((_) {
      debugPrint('🟢 Socket connected');
      _isConnected = true;
      _emitSetup();
      _onConnected?.call();
    });

    _socket?.onDisconnect((_) {
      debugPrint('🔴 Socket disconnected');
      _isConnected = false;
      _onDisconnected?.call();
    });

    _socket?.on('connected', (data) {
      debugPrint('✅ Setup ACK: $data');
    });

    _socket?.on('chats', (data) {
      debugPrint('📋 Chats received: ${data.runtimeType}');
      if (data is List) {
        debugPrint('📋 Total chats: ${data.length}');
        for (int i = 0; i < data.length; i++) {
          debugPrint('📋 Chat $i: ${data[i]}');
        }
      } else {
        debugPrint('📋 Chats data: $data');
      }
      _onChatsReceived?.call(data);
    });

    _socket?.on('messages', (data) {
      debugPrint('💬 Messages received: ${data.runtimeType}');
      _onMessagesReceived?.call(data);
    });

    _socket?.on('chatCreated', (data) {
      debugPrint('🆕 Chat created: $data');
      _onChatCreated?.call(data);
    });

    _socket?.on('messageSent', (data) {
      debugPrint('📤 Message sent: $data');
      _onMessageSent?.call(data);
    });

    _socket?.on('receiveMessage', (data) {
      debugPrint('📥 Message received: $data');
      _onMessageReceived?.call(data);
    });

    _socket?.on('error', (data) {
      debugPrint('❌ Socket error: $data');
      final errorMessage =
          data is Map ? data['message'] ?? 'Unknown error' : data.toString();
      _onError?.call(errorMessage);
    });
  }

  /// Emit setup event
  void _emitSetup() {
    debugPrint('🔧 Emitting setup...');
    _socket?.emit('setup', {});
  }

  // ==================== Event Emitters ====================

  /// Get all chats for current user
  void emitGetChats() {
    if (!_ensureConnected()) return;
    debugPrint('📤 Emitting getChats...');
    _socket?.emit('getChats', {});
  }

  /// Get messages for a specific chat
  void emitGetMessages({required int chatId, int page = 1, int limit = 20}) {
    if (!_ensureConnected()) return;
    debugPrint(
      '📤 Emitting getMessages for chat $chatId (page: $page, limit: $limit)',
    );
    _socket?.emit('getMessages', {
      'chatId': chatId,
      'page': page,
      'limit': limit,
    });
  }

  /// Send a new message in an existing chat
  void emitNewMessage({
    required int chatId,
    required String content,
    String? fileUrl,
    String messageType = 'text',
  }) {
    if (!_ensureConnected()) return;
    debugPrint('📤 Emitting newMessage to chat $chatId');
    _socket?.emit('newMessage', {
      'chatId': chatId,
      'message': {
        'content': content,
        'fileUrl': fileUrl,
        'messageType': messageType,
      },
    });
  }

  /// Create a new chat with first message
  void emitNewFirstMessage({
    required List<int> memberIds,
    String? chatName,
    required String category,
    required String content,
    String? fileUrl,
    String messageType = 'text',
  }) {
    if (!_ensureConnected()) return;
    debugPrint('📤 Emitting newFirstMessage (category: $category)');
    _socket?.emit('newFirstMessage', {
      'chatMembers': memberIds,
      'chatName': chatName,
      'category': category,
      'message': {
        'content': content,
        'fileUrl': fileUrl,
        'messageType': messageType,
      },
    });
  }

  // ==================== Callback Setters ====================

  void setOnChatsReceived(Function(dynamic) callback) {
    _onChatsReceived = callback;
  }

  void setOnMessagesReceived(Function(dynamic) callback) {
    _onMessagesReceived = callback;
  }

  void setOnChatCreated(Function(dynamic) callback) {
    _onChatCreated = callback;
  }

  void setOnMessageSent(Function(dynamic) callback) {
    _onMessageSent = callback;
  }

  void setOnMessageReceived(Function(dynamic) callback) {
    _onMessageReceived = callback;
  }

  void setOnError(Function(String) callback) {
    _onError = callback;
  }

  void setOnConnected(Function() callback) {
    _onConnected = callback;
  }

  void setOnDisconnected(Function() callback) {
    _onDisconnected = callback;
  }

  // ==================== Helper Methods ====================

  bool _ensureConnected() {
    if (_socket == null || !_socket!.connected) {
      debugPrint('⚠️ Socket not connected. Cannot emit event.');
      return false;
    }
    return true;
  }

  void _clearCallbacks() {
    _onChatsReceived = null;
    _onMessagesReceived = null;
    _onChatCreated = null;
    _onMessageSent = null;
    _onMessageReceived = null;
    _onError = null;
    _onConnected = null;
    _onDisconnected = null;
  }
}
