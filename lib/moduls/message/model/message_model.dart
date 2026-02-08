import 'dart:convert';
import 'dart:typed_data';

class MessageModel {
  final String id;
  final String chatId;
  final String content;
  final String senderId;
  final String senderName;
  final String senderAvatarUrl;
  final List<MessageAttachment> attachments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.attachments,
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
        attachments: <MessageAttachment>[],
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
      attachments: MessageAttachment.fromJsonList(json['attachments']),
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
      'attachments': attachments.map((item) => item.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class MessageAttachment {
  final String id;
  final String name;
  final String url;
  final String mimeType;
  final int? size;
  final Uint8List? bytes;

  const MessageAttachment({
    required this.id,
    required this.name,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.bytes,
  });

  factory MessageAttachment.fromDynamic(dynamic data) {
    if (data is Map) {
      final json = Map<String, dynamic>.from(data);
      String readString(dynamic value) => value?.toString() ?? '';
      int? readInt(dynamic value) {
        if (value == null) return null;
        if (value is int) return value;
        return int.tryParse(value.toString());
      }
      String readUrl() {
        return readString(json['url']).isNotEmpty
            ? readString(json['url'])
            : readString(json['secure_url']).isNotEmpty
                ? readString(json['secure_url'])
                : readString(json['fileUrl']).isNotEmpty
                    ? readString(json['fileUrl'])
                    : readString(json['path']).isNotEmpty
                        ? readString(json['path'])
                        : readString(json['file']).isNotEmpty
                            ? readString(json['file'])
                            : readString(json['location']);
      }
      String readName() {
        return readString(json['name']).isNotEmpty
            ? readString(json['name'])
            : readString(json['fileName']).isNotEmpty
                ? readString(json['fileName'])
                : readString(json['filename']).isNotEmpty
                    ? readString(json['filename'])
                    : readString(json['originalName']);
      }
      String readMime() {
        return readString(json['mimeType']).isNotEmpty
            ? readString(json['mimeType'])
            : readString(json['mimetype']).isNotEmpty
                ? readString(json['mimetype'])
                : readString(json['contentType']).isNotEmpty
                    ? readString(json['contentType'])
                    : readString(json['fileType']).isNotEmpty
                        ? readString(json['fileType'])
                        : readString(json['type']);
      }
      int? readSize() {
        return readInt(json['size']) ??
            readInt(json['fileSize']) ??
            readInt(json['bytes']);
      }

      final url = readUrl();
      final name = readName().isNotEmpty ? readName() : _nameFromUrl(url);
      final mime = readMime().isNotEmpty ? readMime() : _mimeFromName(name);
      return MessageAttachment(
        id: readString(json['_id'] ?? json['id']),
        name: name,
        url: url,
        mimeType: mime,
        size: readSize(),
        bytes: _readBytes(json['data']),
      );
    }
    final value = data?.toString() ?? '';
    final name = value.split('/').last;
    return MessageAttachment(
      id: '',
      name: name,
      url: value,
      mimeType: _mimeFromName(name),
      size: null,
      bytes: null,
    );
  }

  static List<MessageAttachment> fromJsonList(dynamic data) {
    if (data is List) {
      return data.map(MessageAttachment.fromDynamic).toList();
    }
    return <MessageAttachment>[];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'mimeType': mimeType,
      'size': size,
    };
  }
}

Uint8List? _readBytes(dynamic value) {
  if (value == null) return null;
  if (value is Uint8List) return value;
  if (value is String && value.isNotEmpty) {
    try {
      return base64Decode(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

String _nameFromUrl(String url) {
  if (url.isEmpty) return '';
  final cleaned = url.split('?').first;
  return cleaned.split('/').last;
}

String _mimeFromName(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.pdf')) return 'application/pdf';
  if (lower.endsWith('.doc')) return 'application/msword';
  if (lower.endsWith('.docx')) {
    return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  }
  if (lower.endsWith('.ppt')) return 'application/vnd.ms-powerpoint';
  if (lower.endsWith('.pptx')) {
    return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
  }
  if (lower.endsWith('.xls')) return 'application/vnd.ms-excel';
  if (lower.endsWith('.xlsx')) {
    return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  }
  if (lower.endsWith('.txt')) return 'text/plain';
  return '';
}
