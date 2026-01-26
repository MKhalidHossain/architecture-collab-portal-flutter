class MessageModel {
  final String id;
  final String chatId;
  final String content;
  final String senderId;
  final String senderName;
  final String senderAvatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  static List<MessageModel> fromJsonList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => MessageModel.fromJson(item))
          .toList();
    }
    return <MessageModel>[];
  }

  factory MessageModel.fromJson(dynamic data) {
    if (data is! Map) {
      return const MessageModel(
        id: '',
        chatId: '',
        content: '',
        senderId: '',
        senderName: '',
        senderAvatarUrl: '',
        createdAt: null,
        updatedAt: null,
      );
    }
    final json = Map<String, dynamic>.from(data);
    final senderMap = json['sender'];
    final sender = senderMap is Map ? Map<String, dynamic>.from(senderMap) : {};
    final avatarMap = sender['avatar'];
    final avatar = avatarMap is Map ? Map<String, dynamic>.from(avatarMap) : {};

    String readString(dynamic value) => value?.toString() ?? '';
    DateTime? readDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString());
    }

    String chatId = '';
    final chat = json['chat'];
    if (chat is Map) {
      final chatMap = Map<String, dynamic>.from(chat);
      chatId = readString(chatMap['_id']);
      if (chatId.isEmpty) {
        chatId = readString(chatMap['id']);
      }
    } else {
      chatId = readString(chat);
    }

    return MessageModel(
      id: readString(json['_id']).isNotEmpty
          ? readString(json['_id'])
          : readString(json['id']),
      chatId: chatId,
      content: readString(json['content']),
      senderId: readString(sender['_id']).isNotEmpty
          ? readString(sender['_id'])
          : readString(sender['id']),
      senderName: readString(sender['name']),
      senderAvatarUrl: readString(avatar['url']),
      createdAt: readDate(json['createdAt']),
      updatedAt: readDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
