import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;

  final List<Function(dynamic)> _onChatsReceived = [];
  final List<Function(dynamic)> _onMessagesReceived = [];
  final List<Function(dynamic)> _onChatCreated = [];
  final List<Function(dynamic)> _onMessageSent = [];
  final List<Function(dynamic)> _onMessageReceived = [];
  final List<Function(String)> _onError = [];
  final List<Function()> _onConnected = [];
  final List<Function()> _onDisconnected = [];

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
      for (final cb in _onConnected) {
        cb();
      }
    });

    _socket?.onDisconnect((_) {
      debugPrint('🔴 Socket disconnected');
      _isConnected = false;
      for (final cb in _onDisconnected) {
        cb();
      }
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
      for (final cb in _onChatsReceived) {
        cb(data);
      }
    });

    _socket?.on('messages', (data) {
      debugPrint('💬 Messages received: ${data.runtimeType}');
      for (final cb in _onMessagesReceived) {
        cb(data);
      }
    });

    _socket?.on('chatCreated', (data) {
      debugPrint('🆕 Chat created: $data');
      for (final cb in _onChatCreated) {
        cb(data);
      }
    });

    _socket?.on('messageSent', (data) {
      debugPrint('📤 Message sent: $data');
      for (final cb in _onMessageSent) {
        cb(data);
      }
    });

    _socket?.on('receiveMessage', (data) {
      debugPrint('📥 Message received: $data');
      for (final cb in _onMessageReceived) {
        cb(data);
      }
    });

    _socket?.on('error', (data) {
      debugPrint('❌ Socket error: $data');
      final errorMessage =
          data is Map ? data['message'] ?? 'Unknown error' : data.toString();
      for (final cb in _onError) {
        cb(errorMessage);
      }
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

  // Backward-compatible "set" APIs now replace existing listeners with a single one
  void setOnChatsReceived(Function(dynamic) callback) {
    _onChatsReceived
      ..clear()
      ..add(callback);
  }

  void setOnMessagesReceived(Function(dynamic) callback) {
    _onMessagesReceived
      ..clear()
      ..add(callback);
  }

  void setOnChatCreated(Function(dynamic) callback) {
    _onChatCreated
      ..clear()
      ..add(callback);
  }

  void setOnMessageSent(Function(dynamic) callback) {
    _onMessageSent
      ..clear()
      ..add(callback);
  }

  void setOnMessageReceived(Function(dynamic) callback) {
    _onMessageReceived
      ..clear()
      ..add(callback);
  }

  void setOnError(Function(String) callback) {
    _onError
      ..clear()
      ..add(callback);
  }

  void setOnConnected(Function() callback) {
    _onConnected
      ..clear()
      ..add(callback);
  }

  void setOnDisconnected(Function() callback) {
    _onDisconnected
      ..clear()
      ..add(callback);
  }

  // Add/remove APIs to support multiple listeners without overwriting
  void addOnChatsReceived(Function(dynamic) callback) => _onChatsReceived.add(callback);
  void removeOnChatsReceived(Function(dynamic) callback) => _onChatsReceived.remove(callback);

  void addOnMessagesReceived(Function(dynamic) callback) => _onMessagesReceived.add(callback);
  void removeOnMessagesReceived(Function(dynamic) callback) => _onMessagesReceived.remove(callback);

  void addOnChatCreated(Function(dynamic) callback) => _onChatCreated.add(callback);
  void removeOnChatCreated(Function(dynamic) callback) => _onChatCreated.remove(callback);

  void addOnMessageSent(Function(dynamic) callback) => _onMessageSent.add(callback);
  void removeOnMessageSent(Function(dynamic) callback) => _onMessageSent.remove(callback);

  void addOnMessageReceived(Function(dynamic) callback) => _onMessageReceived.add(callback);
  void removeOnMessageReceived(Function(dynamic) callback) => _onMessageReceived.remove(callback);

  void addOnError(Function(String) callback) => _onError.add(callback);
  void removeOnError(Function(String) callback) => _onError.remove(callback);

  void addOnConnected(Function() callback) => _onConnected.add(callback);
  void removeOnConnected(Function() callback) => _onConnected.remove(callback);

  void addOnDisconnected(Function() callback) => _onDisconnected.add(callback);
  void removeOnDisconnected(Function() callback) => _onDisconnected.remove(callback);

  // ==================== Helper Methods ====================

  bool _ensureConnected() {
    if (_socket == null || !_socket!.connected) {
      debugPrint('⚠️ Socket not connected. Cannot emit event.');
      return false;
    }
    return true;
  }

  void _clearCallbacks() {
    _onChatsReceived.clear();
    _onMessagesReceived.clear();
    _onChatCreated.clear();
    _onMessageSent.clear();
    _onMessageReceived.clear();
    _onError.clear();
    _onConnected.clear();
    _onDisconnected.clear();
  }
}
