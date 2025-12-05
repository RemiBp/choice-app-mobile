import 'package:choice_app/models/chat_model.dart';
import 'package:choice_app/network/socket_service.dart';
import 'package:flutter/material.dart';

import '../../../common/utils.dart';
import '../../../res/strings.dart';

class ChatProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  List<Chat> _allChats = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Chat> get allChats => _allChats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  int get _currentUserId {
    return PreferenceUtils.getInt(Strings.userId, 0);
  }

  // Filtered chats by category
  List<Chat> get friendsChats => _filterChatsByCategory('FRIENDS');
  List<Chat> get restaurantsChats => _filterChatsByCategory('RESTAURANTS');
  List<Chat> get leisureChats => _filterChatsByCategory('LEISURE');
  List<Chat> get wellnessChats => _filterChatsByCategory('WELLNESS');

  void init(BuildContext context) {
    _setupSocketListeners();

    if (_socketService.isConnected) {
      loadChats();
    }
  }

  /// Setup socket event listeners
  void _setupSocketListeners() {
    _socketService.addOnChatsReceived(_handleChatsReceived);
    _socketService.addOnChatCreated(_handleChatCreated);
    _socketService.addOnMessageReceived(_handleNewMessage);
    _socketService.addOnMessageSent(_handleMessageSent);
    _socketService.addOnError(_handleError);
    _socketService.addOnConnected(() {
      debugPrint('🟢 Chat Provider: Socket connected, loading chats...');
      loadChats();
    });
  }

  /// Load all chats from server
  void loadChats() {
    if (!_socketService.isConnected) {
      debugPrint('⚠️ Cannot load chats: Socket not connected');
      _error = 'Connection not available';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    _socketService.emitGetChats();
  }

  /// Handle chats received from server
  void _handleChatsReceived(dynamic data) {
    try {
      debugPrint('📋 Handling chats received: ${data.runtimeType}');

      if (data is List) {
        debugPrint('📋 Raw chats data (List with ${data.length} items):');
        for (int i = 0; i < data.length; i++) {
          debugPrint('  ┌─ Chat $i ──────────────────────────────────────');
          debugPrint('  │ Raw JSON: ${data[i]}');
          if (data[i] is Map) {
            final chatMap = data[i] as Map<String, dynamic>;
            debugPrint('  │ ID: ${chatMap['id']}');
            debugPrint('  │ Name: ${chatMap['name']}');
            debugPrint('  │ IsGroupChat: ${chatMap['isGroupChat']}');
            debugPrint('  │ Category: ${chatMap['category']}');
            debugPrint('  │ CreatedAt: ${chatMap['createdAt']}');
            debugPrint('  │ CreatorId: ${chatMap['creatorId']}');
            debugPrint('  │ LastMessageId: ${chatMap['lastMessageId']}');
            if (chatMap['lastMessage'] != null) {
              debugPrint('  │ LastMessage: ${chatMap['lastMessage']}');
            }
            if (chatMap['members'] != null) {
              debugPrint('  │ Members (${(chatMap['members'] as List).length}):');
              for (int j = 0; j < (chatMap['members'] as List).length; j++) {
                final member = (chatMap['members'] as List)[j];
                debugPrint('  │   └─ Member $j: $member');
              }
            }
          }
          debugPrint('  └──────────────────────────────────────────────');
        }

        _allChats = data.map((chatJson) {
          try {
            final chat = Chat.fromJson(chatJson);
            return chat;
          } catch (e) {
            debugPrint('❌ Error parsing chat $chatJson: $e');
            rethrow;
          }
        }).toList();

        debugPrint('✅ Successfully loaded ${_allChats.length} chats');
        debugPrint('📋 Parsed chats details:');
        for (int i = 0; i < _allChats.length; i++) {
          final chat = _allChats[i];
          debugPrint('  ┌─ Parsed Chat $i ─────────────────────────────');
          debugPrint('  │ ID: ${chat.id}');
          debugPrint('  │ Name: ${chat.name}');
          debugPrint('  │ IsGroupChat: ${chat.isGroupChat}');
          debugPrint('  │ Category: ${chat.category}');
          debugPrint('  │ CreatedAt: ${chat.createdAt}');
          debugPrint('  │ CreatorId: ${chat.creatorId}');
          debugPrint('  │ LastMessageId: ${chat.lastMessageId}');
          if (chat.lastMessage != null) {
            debugPrint('  │ LastMessage:');
            debugPrint('  │   - ID: ${chat.lastMessage!.id}');
            debugPrint('  │   - Content: ${chat.lastMessage!.content}');
            debugPrint('  │   - SenderId: ${chat.lastMessage!.senderId}');
            debugPrint('  │   - CreatedAt: ${chat.lastMessage!.createdAt}');
          }
          debugPrint('  │ Members (${chat.members.length}):');
          for (int j = 0; j < chat.members.length; j++) {
            final member = chat.members[j];
            debugPrint('  │   └─ Member $j:');
            debugPrint('  │      - UserId: ${member.userId}');
            debugPrint('  │      - IsAdmin: ${member.isAdmin}');
            if (member.user != null) {
              debugPrint('  │      - User:');
              debugPrint('  │        * ID: ${member.user!.id}');
              debugPrint('  │        * FullName: ${member.user!.fullName}');
              debugPrint('  │        * UserName: ${member.user!.userName}');
              debugPrint('  │        * ProfilePicture: ${member.user!.profilePicture}');
            }
          }
          debugPrint('  └──────────────────────────────────────────────');
        }
      } else {
        debugPrint('⚠️ Unexpected data type for chats: ${data.runtimeType}');
        debugPrint('⚠️ Data content: $data');
        _allChats = [];
      }

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing chats: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      _error = 'Failed to load chats';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Handle new chat created
  void _handleChatCreated(dynamic data) {
    try {
      debugPrint('🆕 Handling chat created: $data');

      if (data is Map<String, dynamic>) {
        loadChats();
      }
    } catch (e) {
      debugPrint('❌ Error handling chat created: $e');
    }
  }

  /// Handle new message received (update last message)
  void _handleNewMessage(dynamic data) {
    try {
      debugPrint('📥 Handling new message in chat list: $data');

      if (data is Map<String, dynamic>) {
        final message = Message.fromJson(data);
        _updateLastMessage(message);
      }
    } catch (e) {
      debugPrint('❌ Error handling new message: $e');
    }
  }

  /// Handle message sent confirmation
  void _handleMessageSent(dynamic data) {
    try {
      debugPrint('📤 Handling message sent in chat list: $data');

      if (data is Map<String, dynamic>) {
        final message = Message.fromJson(data);
        _updateLastMessage(message);
      }
    } catch (e) {
      debugPrint('❌ Error handling message sent: $e');
    }
  }

  /// Update last message for a chat
  void _updateLastMessage(Message message) {
    final chatIndex = _allChats.indexWhere((chat) => chat.id == message.chatId);
    if (chatIndex != -1) {
      final updatedChat = Chat(
        id: _allChats[chatIndex].id,
        name: _allChats[chatIndex].name,
        isGroupChat: _allChats[chatIndex].isGroupChat,
        category: _allChats[chatIndex].category,
        createdAt: _allChats[chatIndex].createdAt,
        creatorId: _allChats[chatIndex].creatorId,
        lastMessageId: message.id,
        lastMessage: message,
        members: _allChats[chatIndex].members,
      );

      _allChats[chatIndex] = updatedChat;

      _allChats.removeAt(chatIndex);
      _allChats.insert(0, updatedChat);

      notifyListeners();
    }
  }

  /// Handle socket errors
  void _handleError(String error) {
    debugPrint('❌ Chat Provider: Socket error: $error');
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Filter chats by category
  List<Chat> _filterChatsByCategory(String category) {
    var chats = _allChats.where((chat) => chat.category == category).toList();

    if (_searchQuery.isNotEmpty) {
      chats =
          chats.where((chat) {
            final displayName =
                chat.getDisplayName(_currentUserId).toLowerCase();
            final query = _searchQuery.toLowerCase();
            return displayName.contains(query);
          }).toList();
    }

    return chats;
  }

  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Refresh chats (pull to refresh)
  Future<void> refreshChats() async {
    loadChats();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _socketService.removeOnChatsReceived(_handleChatsReceived);
    _socketService.removeOnChatCreated(_handleChatCreated);
    _socketService.removeOnMessageReceived(_handleNewMessage);
    _socketService.removeOnMessageSent(_handleMessageSent);
    _socketService.removeOnError(_handleError);
    super.dispose();
  }
}
