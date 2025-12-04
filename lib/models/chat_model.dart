class Chat {
  final int id;
  final String name;
  final bool isGroupChat;
  final String category; // FRIENDS | RESTAURANTS | LEISURE | WELLNESS
  final DateTime createdAt;
  final int? creatorId;
  final int? lastMessageId;
  final Message? lastMessage;
  final List<ChatMember> members;

  Chat({
    required this.id,
    required this.name,
    required this.isGroupChat,
    required this.category,
    required this.createdAt,
    this.creatorId,
    this.lastMessageId,
    this.lastMessage,
    this.members = const [],
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isGroupChat: json['isGroupChat'] ?? false,
      category: json['category'] ?? 'FRIENDS',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      creatorId: json['creatorId'],
      lastMessageId: json['lastMessageId'],
      lastMessage:
          json['lastMessage'] != null
              ? Message.fromJson(json['lastMessage'])
              : null,
      members:
          json['members'] != null
              ? (json['members'] as List)
                  .map((member) => ChatMember.fromJson(member))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isGroupChat': isGroupChat,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'creatorId': creatorId,
      'lastMessageId': lastMessageId,
      'lastMessage': lastMessage?.toJson(),
      'members': members.map((member) => member.toJson()).toList(),
    };
  }

  // Helper to get display name for 1-1 chats
  String getDisplayName(int currentUserId) {
    if (isGroupChat || name.isNotEmpty) {
      return name;
    }
    // For 1-1 chats, find the other participant
    final otherMember = members.firstWhere(
      (member) => member.userId != currentUserId,
      orElse: () => members.first,
    );
    return otherMember.user?.fullName ?? 'Unknown User';
  }

  // Helper to get avatar for 1-1 chats
  String? getAvatarUrl(int currentUserId) {
    if (isGroupChat) {
      return null; // Group chats might use a default group icon
    }
    final otherMember = members.firstWhere(
      (member) => member.userId != currentUserId,
      orElse: () => members.first,
    );
    return otherMember.user?.profilePicture;
  }
}

class ChatMember {
  final int chatId;
  final int userId;
  final bool isAdmin;
  final DateTime joinedAt;
  final ChatUser? user;

  ChatMember({
    required this.chatId,
    required this.userId,
    required this.isAdmin,
    required this.joinedAt,
    this.user,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      chatId: json['chatId'] ?? 0,
      userId: json['userId'] ?? 0,
      isAdmin: json['isAdmin'] ?? false,
      joinedAt:
          json['joinedAt'] != null
              ? DateTime.parse(json['joinedAt'])
              : DateTime.now(),
      user: json['user'] != null ? ChatUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'userId': userId,
      'isAdmin': isAdmin,
      'joinedAt': joinedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}

class ChatUser {
  final int id;
  final String fullName;
  final String? userName;
  final String? email;
  final String? profilePicture;

  ChatUser({
    required this.id,
    required this.fullName,
    this.userName,
    this.email,
    this.profilePicture,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      userName: json['userName'],
      email: json['email'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}

class Message {
  final int id;
  final int chatId;
  final int senderId;
  final String content;
  final String? fileUrl;
  final String messageType; // text | file | audio
  final DateTime createdAt;
  final bool isRead;
  final ChatUser? sender;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.fileUrl,
    this.messageType = 'text',
    required this.createdAt,
    this.isRead = false,
    this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // Extract sender data first
    final senderData =
        json['sender'] != null ? ChatUser.fromJson(json['sender']) : null;

    // Get senderId from either the top level or from sender.id
    final senderId = json['senderId'] ?? senderData?.id ?? 0;

    return Message(
      id: json['id'] ?? 0,
      chatId: json['chatId'] ?? 0,
      senderId: senderId,
      content: json['content'] ?? '',
      fileUrl: json['fileUrl'],
      messageType: json['messageType'] ?? 'text',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      isRead: json['isRead'] ?? false,
      sender: senderData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'fileUrl': fileUrl,
      'messageType': messageType,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'sender': sender?.toJson(),
    };
  }
}
