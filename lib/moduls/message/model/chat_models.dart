class ChatAvatar {
  final String publicId;
  final String url;

  const ChatAvatar({
    required this.publicId,
    required this.url,
  });

  factory ChatAvatar.fromDynamic(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return ChatAvatar(
        publicId: _readString(map['public_id']),
        url: _readString(map['url']),
      );
    }
    return const ChatAvatar(publicId: '', url: '');
  }
}

class ChatUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final ChatAvatar avatar;

  const ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatar,
  });

  factory ChatUser.fromDynamic(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return ChatUser(
        id: _readString(map['_id'] ?? map['id']),
        name: _readString(map['name']),
        email: _readString(map['email']),
        role: _readString(map['role']),
        avatar: ChatAvatar.fromDynamic(map['avatar']),
      );
    }
    return const ChatUser(
      id: '',
      name: '',
      email: '',
      role: '',
      avatar: ChatAvatar(publicId: '', url: ''),
    );
  }
}

class ChatLatestMessage {
  final String id;
  final ChatUser sender;
  final String content;
  final String chatId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatLatestMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatLatestMessage.fromDynamic(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return ChatLatestMessage(
        id: _readString(map['_id'] ?? map['id']),
        sender: ChatUser.fromDynamic(map['sender']),
        content: _readString(map['content']),
        chatId: _readString(map['chat']),
        createdAt: _readDate(map['createdAt']),
        updatedAt: _readDate(map['updatedAt']),
      );
    }
    return const ChatLatestMessage(
      id: '',
      sender: ChatUser(
        id: '',
        name: '',
        email: '',
        role: '',
        avatar: ChatAvatar(publicId: '', url: ''),
      ),
      content: '',
      chatId: '',
      createdAt: null,
      updatedAt: null,
    );
  }
}

class ChatModel {
  final String id;
  final String projectId;
  final String chatName;
  final bool isGroupChat;
  final List<ChatUser> users;
  final ChatLatestMessage? latestMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatModel({
    required this.id,
    required this.projectId,
    required this.chatName,
    required this.isGroupChat,
    required this.users,
    required this.latestMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final usersRaw = json['users'];
    final users = usersRaw is List
        ? usersRaw.map((e) => ChatUser.fromDynamic(e)).toList()
        : <ChatUser>[];
    String readString(dynamic value) => value?.toString() ?? '';
    String extractProjectId(dynamic value) {
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        return readString(map['_id']).isNotEmpty
            ? readString(map['_id'])
            : readString(map['id']);
      }
      return readString(value);
    }
    return ChatModel(
      id: _readString(json['_id'] ?? json['id']),
      projectId: readString(json['projectId']).isNotEmpty
          ? readString(json['projectId'])
          : readString(json['project_id']).isNotEmpty
              ? readString(json['project_id'])
              : extractProjectId(json['project']),
      chatName: _readString(json['chatName']),
      isGroupChat: json['isGroupChat'] == true,
      users: users,
      latestMessage: json['latestMessage'] != null
          ? ChatLatestMessage.fromDynamic(json['latestMessage'])
          : null,
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
    );
  }

  static List<ChatModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .whereType<Map>()
          .map((item) => ChatModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return <ChatModel>[];
  }
}

String _readString(dynamic value) => value?.toString() ?? '';

DateTime? _readDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
