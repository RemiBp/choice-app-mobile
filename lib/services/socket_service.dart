import 'package:socket_io_client/socket_io_client.dart' as io;
import '../config/app_config.dart';
import 'storage_service.dart';

class SocketService {
  static io.Socket? _socket;

  static io.Socket? get socket => _socket;
  static bool get isConnected => _socket?.connected ?? false;

  static Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;

    final token = await StorageService.getAccessToken();
    if (token == null) return;

    _socket = io.io(
      AppConfig.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'token': token})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _socket!.emit('setup');
    });

    _socket!.onDisconnect((_) {});
    _socket!.onError((err) {});
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  // ── Emit helpers ──────────────────────────────

  static void sendFirstMessage({
    required List<int> chatMembers,
    required String message,
    String messageType = 'text',
  }) {
    _socket?.emit('newFirstMessage', {
      'data': {
        'chatMembers': chatMembers,
        'message': message,
        'messageType': messageType,
      },
    });
  }

  static void sendMessage({
    required int chatId,
    required String content,
    String messageType = 'text',
    String? fileUrl,
  }) {
    _socket?.emit('newMessage', {
      'chatId': chatId,
      'content': content,
      'messageType': messageType,
      if (fileUrl != null) 'fileUrl': fileUrl,
    });
  }

  static void getChats() => _socket?.emit('getChats');

  static void getMessages({required int chatId, int page = 1, int limit = 30}) {
    _socket?.emit('getMessages', {'chatId': chatId, 'page': page, 'limit': limit});
  }

  // ── Listener helpers ─────────────────────────

  static void onReceiveMessage(void Function(dynamic) handler) =>
      _socket?.on('receiveMessage', handler);

  static void onMessageSent(void Function(dynamic) handler) =>
      _socket?.on('messageSent', handler);

  static void onChatCreated(void Function(dynamic) handler) =>
      _socket?.on('chatCreated', handler);

  static void onChats(void Function(dynamic) handler) =>
      _socket?.on('chats', handler);

  static void onMessages(void Function(dynamic) handler) =>
      _socket?.on('messages', handler);

  static void off(String event) => _socket?.off(event);
}
