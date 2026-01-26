class SettingsNotifications {
  final bool messages;
  final bool approvals;
  final bool milestones;
  final bool projectUpdates;
  final bool invoices;

  const SettingsNotifications({
    required this.messages,
    required this.approvals,
    required this.milestones,
    required this.projectUpdates,
    required this.invoices,
  });

  factory SettingsNotifications.empty() {
    return const SettingsNotifications(
      messages: false,
      approvals: false,
      milestones: false,
      projectUpdates: false,
      invoices: false,
    );
  }

  factory SettingsNotifications.fromJson(Map<String, dynamic> json) {
    return SettingsNotifications(
      messages: _readBool(json['messages']),
      approvals: _readBool(json['approvals']),
      milestones: _readBool(json['milestones']),
      projectUpdates: _readBool(json['projectUpdates']),
      invoices: _readBool(json['invoices']),
    );
  }

  SettingsNotifications copyWith({
    bool? messages,
    bool? approvals,
    bool? milestones,
    bool? projectUpdates,
    bool? invoices,
  }) {
    return SettingsNotifications(
      messages: messages ?? this.messages,
      approvals: approvals ?? this.approvals,
      milestones: milestones ?? this.milestones,
      projectUpdates: projectUpdates ?? this.projectUpdates,
      invoices: invoices ?? this.invoices,
    );
  }
}

class SettingsData {
  final SettingsNotifications notifications;
  final String language;

  const SettingsData({
    required this.notifications,
    required this.language,
  });

  factory SettingsData.empty() {
    return SettingsData(
      notifications: SettingsNotifications.empty(),
      language: '',
    );
  }

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    final notifications =
        json['notifications'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(
                json['notifications'] as Map<String, dynamic>,
              )
            : <String, dynamic>{};
    return SettingsData(
      notifications: SettingsNotifications.fromJson(notifications),
      language: _readString(json['language']),
    );
  }

  SettingsData copyWith({
    SettingsNotifications? notifications,
    String? language,
  }) {
    return SettingsData(
      notifications: notifications ?? this.notifications,
      language: language ?? this.language,
    );
  }
}

class SettingsUpdateResponseModel {
  final String message;
  final SettingsData settings;

  const SettingsUpdateResponseModel({
    required this.message,
    required this.settings,
  });

  factory SettingsUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    final settings =
        json['settings'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(
                json['settings'] as Map<String, dynamic>,
              )
            : <String, dynamic>{};
    return SettingsUpdateResponseModel(
      message: _readString(json['message'], fallback: 'Settings updated'),
      settings: SettingsData.fromJson(settings),
    );
  }
}

class SettingsNotificationsUpdate {
  final bool? messages;
  final bool? approvals;
  final bool? milestones;
  final bool? projectUpdates;
  final bool? invoices;

  const SettingsNotificationsUpdate({
    this.messages,
    this.approvals,
    this.milestones,
    this.projectUpdates,
    this.invoices,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (messages != null) {
      data['messages'] = messages;
    }
    if (approvals != null) {
      data['approvals'] = approvals;
    }
    if (milestones != null) {
      data['milestones'] = milestones;
    }
    if (projectUpdates != null) {
      data['projectUpdates'] = projectUpdates;
    }
    if (invoices != null) {
      data['invoices'] = invoices;
    }
    return data;
  }
}

class SettingsUpdateRequestModel {
  final SettingsNotificationsUpdate? notifications;
  final String? language;

  const SettingsUpdateRequestModel({
    this.notifications,
    this.language,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (notifications != null) {
      final notificationsJson = notifications!.toJson();
      if (notificationsJson.isNotEmpty) {
        data['notifications'] = notificationsJson;
      }
    }
    if (language != null && language!.trim().isNotEmpty) {
      data['language'] = language;
    }
    return data;
  }
}

bool _readBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString().toLowerCase() == 'true';
}

String _readString(dynamic value, {String fallback = ''}) {
  final text = value?.toString() ?? '';
  return text.isNotEmpty ? text : fallback;
}
