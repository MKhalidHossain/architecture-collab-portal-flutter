class HomeDashboardResponse {
  final String userName;
  final HomeStats stats;
  final List<HomeProject> projects;
  final List<HomeRecentActivity> recentActivity;

  const HomeDashboardResponse({
    required this.userName,
    required this.stats,
    required this.projects,
    required this.recentActivity,
  });

  factory HomeDashboardResponse.empty() {
    return const HomeDashboardResponse(
      userName: '',
      stats: HomeStats.empty(),
      projects: <HomeProject>[],
      recentActivity: <HomeRecentActivity>[],
    );
  }

  factory HomeDashboardResponse.fromJson(Map<String, dynamic> json) {
    return HomeDashboardResponse(
      userName: _readString(json['userName']),
      stats: HomeStats.fromJson(_readMap(json['stats'])),
      projects: _readList(json['projects'], (item) {
        return HomeProject.fromJson(item);
      }),
      recentActivity: _readList(json['recentActivity'], (item) {
        return HomeRecentActivity.fromJson(item);
      }),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'stats': stats.toJson(),
      'projects': projects.map((item) => item.toJson()).toList(),
      'recentActivity': recentActivity.map((item) => item.toJson()).toList(),
    };
  }
}

class HomeStats {
  final int active;
  final int pending;
  final int documents;

  const HomeStats({
    required this.active,
    required this.pending,
    required this.documents,
  });

  const HomeStats.empty()
      : active = 0,
        pending = 0,
        documents = 0;

  factory HomeStats.fromJson(Map<String, dynamic> json) {
    return HomeStats(
      active: _readInt(json['active']),
      pending: _readInt(json['pending']),
      documents: _readInt(json['documents']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'pending': pending,
      'documents': documents,
    };
  }
}

class HomeProject {
  final String id;
  final String name;
  final String status;
  final DateTime? deadline;
  final String coverImage;
  final int milestoneCurrentStep;
  final String milestoneLabel;
  final List<HomeTeamAvatar> teamAvatars;

  const HomeProject({
    required this.id,
    required this.name,
    required this.status,
    required this.deadline,
    required this.coverImage,
    required this.milestoneCurrentStep,
    required this.milestoneLabel,
    required this.teamAvatars,
  });

  factory HomeProject.fromJson(Map<String, dynamic> json) {
    return HomeProject(
      id: _readString(json['_id']),
      name: _readString(json['name']),
      status: _readString(json['status']),
      deadline: _readDate(json['deadline']),
      coverImage: _readString(json['coverImage']),
      milestoneCurrentStep: _readInt(json['milestoneCurrentStep']),
      milestoneLabel: _readString(json['milestoneLabel']),
      teamAvatars: _readList(json['teamAvatars'], (item) {
        return HomeTeamAvatar.fromJson(item);
      }),
    );
  }

  int get milestoneCurrent {
    final labelCurrent = _parseLabelPart(milestoneLabel, 0);
    if (milestoneCurrentStep > 0) {
      return milestoneCurrentStep;
    }
    return labelCurrent > 0 ? labelCurrent : 1;
  }

  int get milestoneTotal {
    final labelTotal = _parseLabelPart(milestoneLabel, 1);
    if (labelTotal > 0) {
      return labelTotal;
    }
    if (milestoneCurrentStep > 0) {
      return milestoneCurrentStep;
    }
    return 1;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'coverImage': coverImage,
      'milestoneCurrentStep': milestoneCurrentStep,
      'milestoneLabel': milestoneLabel,
      'teamAvatars': teamAvatars.map((item) => item.toJson()).toList(),
    };
  }

  int _parseLabelPart(String label, int index) {
    if (label.isEmpty) {
      return 0;
    }
    final parts = label.split('/');
    if (index < 0 || index >= parts.length) {
      return 0;
    }
    return _readInt(parts[index].trim());
  }
}

class HomeTeamAvatar {
  final String publicId;
  final String url;

  const HomeTeamAvatar({
    required this.publicId,
    required this.url,
  });

  factory HomeTeamAvatar.fromJson(Map<String, dynamic> json) {
    return HomeTeamAvatar(
      publicId: _readString(json['public_id']),
      url: _readString(json['url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'url': url,
    };
  }
}

class HomeRecentActivity {
  final String type;
  final String text;
  final String subText;
  final DateTime? time;
  final String id;
  final String link;

  const HomeRecentActivity({
    required this.type,
    required this.text,
    required this.subText,
    required this.time,
    required this.id,
    required this.link,
  });

  factory HomeRecentActivity.fromJson(Map<String, dynamic> json) {
    return HomeRecentActivity(
      type: _readString(json['type']),
      text: _readString(json['text']),
      subText: _readString(json['subText']),
      time: _readDate(json['time']),
      id: _readString(json['id']),
      link: _readString(json['link']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'subText': subText,
      'time': time?.toIso8601String(),
      'id': id,
      'link': link,
    };
  }
}

String _readString(dynamic value) => value?.toString() ?? '';

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
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
