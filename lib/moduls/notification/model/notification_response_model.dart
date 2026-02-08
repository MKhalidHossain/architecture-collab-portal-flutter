class NotificationResponse {
  final int unreadCount;
  final List<NotificationItemModel> notifications;

  const NotificationResponse({
    required this.unreadCount,
    required this.notifications,
  });

  factory NotificationResponse.empty() {
    return const NotificationResponse(
      unreadCount: 0,
      notifications: <NotificationItemModel>[],
    );
  }

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      unreadCount: _readInt(json['unreadCount']),
      notifications: _readList(json['notifications'], (item) {
        return NotificationItemModel.fromJson(item);
      }),
    );
  }
}

class NotificationItemModel {
  final String id;
  final String type;
  final String message;
  final NotificationSender sender;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationItemModel({
    required this.id,
    required this.type,
    required this.message,
    required this.sender,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: _readString(json['_id']),
      type: _readString(json['type']),
      message: _readString(json['message']),
      sender: NotificationSender.fromJson(_readMap(json['sender'])),
      isRead: _readBool(json['isRead']),
      createdAt: _readDate(json['createdAt']),
    );
  }

  NotificationItemModel copyWith({
    String? id,
    String? type,
    String? message,
    NotificationSender? sender,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotificationSender {
  final String id;
  final String name;
  final String avatarUrl;

  const NotificationSender({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory NotificationSender.empty() {
    return const NotificationSender(id: '', name: '', avatarUrl: '');
  }

  factory NotificationSender.fromJson(Map<String, dynamic> json) {
    final avatar = _readMap(json['avatar']);
    return NotificationSender(
      id: _readString(json['_id']),
      name: _readString(json['name']),
      avatarUrl: _readString(avatar['url']),
    );
  }
}

String _readString(dynamic value) => value?.toString() ?? '';

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _readBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString().toLowerCase() == 'true';
}

DateTime? _readDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

Map<String, dynamic> _readMap(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
}

List<T> _readList<T>(dynamic value, T Function(Map<String, dynamic>) parse) {
  if (value is! List) return <T>[];
  return value
      .whereType<Map>()
      .map((item) => parse(Map<String, dynamic>.from(item)))
      .toList();
}
