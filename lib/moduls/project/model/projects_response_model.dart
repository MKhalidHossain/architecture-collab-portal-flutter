class ProjectsResponse {
  final List<ProjectResponseModel> projects;

  const ProjectsResponse({required this.projects});

  factory ProjectsResponse.empty() {
    return const ProjectsResponse(projects: <ProjectResponseModel>[]);
  }

  factory ProjectsResponse.fromJson(dynamic json) {
    dynamic payload = json;
    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);
      final nested = map['data'];
      if (nested is Map) {
        payload = nested['projects'] ?? nested['items'] ?? nested['data'] ?? nested;
      } else {
        payload = nested ?? map['projects'] ?? map['items'] ?? map;
      }
    }
    return ProjectsResponse(
      projects: _readList(payload, (item) {
        return ProjectResponseModel.fromJson(item);
      }),
    );
  }
}

class ProjectResponseModel {
  final String id;
  final String projectNo;
  final String name;
  final ProjectClient client;
  final List<ProjectTeamMember> teamMembers;
  final String status;
  final int budget;
  final int totalPaid;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ProjectMilestone> milestones;
  final int overallProgress;
  final ProjectImage coverImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProjectResponseModel({
    required this.id,
    required this.projectNo,
    required this.name,
    required this.client,
    required this.teamMembers,
    required this.status,
    required this.budget,
    required this.totalPaid,
    required this.startDate,
    required this.endDate,
    required this.milestones,
    required this.overallProgress,
    required this.coverImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectResponseModel.fromJson(Map<String, dynamic> json) {
    return ProjectResponseModel(
      id: _readId(json),
      projectNo: _readString(json['projectNo']),
      name: _readString(json['name']),
      client: ProjectClient.fromJson(_readMap(json['client'])),
      teamMembers: _readList(json['teamMembers'], (item) {
        return ProjectTeamMember.fromJson(item);
      }),
      status: _readString(json['status']),
      budget: _readInt(json['budget']),
      totalPaid: _readInt(json['totalPaid']),
      startDate: _readDate(json['startDate']),
      endDate: _readDate(json['endDate']),
      milestones: _readList(json['milestones'], (item) {
        return ProjectMilestone.fromJson(item);
      }),
      overallProgress: _readInt(json['overallProgress']),
      coverImage: ProjectImage.fromDynamic(json['coverImage']),
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
    );
  }

  bool get isCompleted {
    final normalized = status.trim().toLowerCase();
    if (normalized.contains('complete') ||
        normalized.contains('done') ||
        normalized.contains('finished')) {
      return true;
    }
    if (overallProgress >= 100) {
      return true;
    }
    if (milestones.isNotEmpty && milestones.every((item) => item.isCompleted)) {
      return true;
    }
    return false;
  }

  int get totalMilestones => milestones.length;

  int get completedMilestones =>
      milestones.where((item) => item.isCompleted).length;
}

class ProjectImage {
  final String publicId;
  final String url;

  const ProjectImage({
    required this.publicId,
    required this.url,
  });

  factory ProjectImage.fromDynamic(dynamic value) {
    if (value is Map) {
      return ProjectImage.fromJson(Map<String, dynamic>.from(value));
    }
    return ProjectImage(publicId: '', url: _readString(value));
  }

  factory ProjectImage.fromJson(Map<String, dynamic> json) {
    return ProjectImage(
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

class ProjectClient {
  final String id;
  final String name;
  final String email;
  final ProjectImage avatar;

  const ProjectClient({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory ProjectClient.fromJson(Map<String, dynamic> json) {
    return ProjectClient(
      id: _readId(json),
      name: _readString(json['name']),
      email: _readString(json['email']),
      avatar: ProjectImage.fromDynamic(json['avatar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'avatar': avatar.toJson(),
    };
  }
}

class ProjectTeamMember {
  final ProjectUser user;
  final String role;

  const ProjectTeamMember({
    required this.user,
    required this.role,
  });

  factory ProjectTeamMember.fromJson(Map<String, dynamic> json) {
    return ProjectTeamMember(
      user: ProjectUser.fromJson(_readMap(json['user'])),
      role: _readString(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'role': role,
    };
  }
}

class ProjectUser {
  final String id;
  final String name;
  final String role;
  final String email;
  final String employeeId;
  final ProjectImage avatar;

  const ProjectUser({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.employeeId,
    required this.avatar,
  });

  factory ProjectUser.fromJson(Map<String, dynamic> json) {
    return ProjectUser(
      id: _readId(json),
      name: _readString(json['name']),
      role: _readString(json['role']),
      email: _readString(json['email']),
      employeeId: _readString(json['employeeId']),
      avatar: ProjectImage.fromDynamic(json['avatar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role': role,
      'email': email,
      'employeeId': employeeId,
      'avatar': avatar.toJson(),
    };
  }
}

class ProjectMilestone {
  final String id;
  final String name;
  final String status;
  final int progress;
  final bool isEnabled;

  const ProjectMilestone({
    required this.id,
    required this.name,
    required this.status,
    required this.progress,
    required this.isEnabled,
  });

  factory ProjectMilestone.fromJson(Map<String, dynamic> json) {
    return ProjectMilestone(
      id: _readId(json),
      name: _readString(json['name']),
      status: _readString(json['status']),
      progress: _readInt(json['progress']),
      isEnabled: _readBool(json['isEnabled']),
    );
  }

  bool get isCompleted {
    final normalized = status.trim().toLowerCase();
    if (normalized.contains('complete') ||
        normalized.contains('done') ||
        normalized.contains('finished')) {
      return true;
    }
    return progress >= 100;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'status': status,
      'progress': progress,
      'isEnabled': isEnabled,
    };
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
  final text = value?.toString().toLowerCase();
  return text == 'true' || text == '1' || text == 'yes';
}

DateTime? _readDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

String _readId(Map<String, dynamic> json) {
  final candidates = [
    json['_id'],
    json['id'],
  ];
  for (final value in candidates) {
    final text = _readString(value);
    if (text.isNotEmpty) {
      return text;
    }
  }
  return '';
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
