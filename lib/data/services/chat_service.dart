import 'package:choice_app/data/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket _socket;
  final String _baseUrl = 'http://localhost:6543'; // Using same base as ApiService mostly

  // Singleton
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void initSocket(String token) {
    if (_isConnected) return;

    _socket = IO.io(_baseUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .setExtraHeaders({'token': token})
        .disableAutoConnect()
        .build());

    _socket.connect();

    _socket.onConnect((_) {
      debugPrint('✅ Socket Connected');
      _isConnected = true;
      _socket.emit('setup'); // Join own room
    });

    _socket.onDisconnect((_) {
      debugPrint('❌ Socket Disconnected');
      _isConnected = false;
    });

    _socket.on('error', (data) {
      debugPrint('🚨 Socket Error: $data');
    });
  }

  void disconnect() {
    _socket.disconnect();
    _isConnected = false;
  }

  // --- Emitters ---

  void sendFirstMessage(Map<String, dynamic> data) {
    _socket.emit('newFirstMessage', data);
  }

  void sendMessage(Map<String, dynamic> data) {
    _socket.emit('newMessage', data);
  }

  void getMessages(int chatId, int page, int limit) {
    _socket.emit('getMessages', {
      'chatId': chatId,
      'page': page,
      'limit': limit,
    });
  }

  void getChats() {
    _socket.emit('getChats');
  }

  // --- Listeners ---

  void onMessageReceived(Function(dynamic) callback) {
    _socket.on('receiveMessage', callback);
  }

  void onMessageSent(Function(dynamic) callback) {
    _socket.on('messageSent', callback); // Echo back
  }

  void onMessagesLoaded(Function(dynamic) callback) {
    _socket.on('messages', callback);
  }

  void onChatsLoaded(Function(dynamic) callback) {
    _socket.on('chats', callback);
  }
}
