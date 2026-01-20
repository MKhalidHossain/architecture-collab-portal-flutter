class ProjectTaskResponseModel {
  final String id;
  final String name;
  final String projectId;
  final String milestoneId;
  final TaskAssignee? assignedTo;
  final String status;
  final String priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TaskSubmission? submission;

  const ProjectTaskResponseModel({
    required this.id,
    required this.name,
    required this.projectId,
    required this.milestoneId,
    required this.assignedTo,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.submission,
  });

  factory ProjectTaskResponseModel.fromJson(Map<String, dynamic> json) {
    return ProjectTaskResponseModel(
      id: _readId(json),
      name: _readString(json['name']),
      projectId: _readString(json['project'] ?? json['projectId']),
      milestoneId: _readString(json['milestoneId'] ?? json['milestone']),
      assignedTo: TaskAssignee.fromDynamic(json['assignedTo']),
      status: _readString(json['status']),
      priority: _readString(json['priority']),
      startDate: _readDate(json['startDate']),
      endDate: _readDate(json['endDate']),
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
      submission: TaskSubmission.fromDynamic(json['submission']),
    );
  }

  static List<ProjectTaskResponseModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .whereType<Map>()
          .map((item) => ProjectTaskResponseModel.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    }
    return <ProjectTaskResponseModel>[];
  }
}

class TaskAssignee {
  final String id;
  final String name;
  final TaskAvatar avatar;

  const TaskAssignee({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory TaskAssignee.fromDynamic(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return TaskAssignee(
        id: _readString(map['_id'] ?? map['id']),
        name: _readString(map['name']),
        avatar: TaskAvatar.fromDynamic(map['avatar']),
      );
    }
    if (value is String) {
      return TaskAssignee(
        id: value,
        name: '',
        avatar: const TaskAvatar(publicId: '', url: ''),
      );
    }
    return const TaskAssignee(
      id: '',
      name: '',
      avatar: TaskAvatar(publicId: '', url: ''),
    );
  }
}

class TaskAvatar {
  final String publicId;
  final String url;

  const TaskAvatar({
    required this.publicId,
    required this.url,
  });

  factory TaskAvatar.fromDynamic(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return TaskAvatar(
        publicId: _readString(map['public_id']),
        url: _readString(map['url']),
      );
    }
    return const TaskAvatar(publicId: '', url: '');
  }
}

class TaskSubmission {
  final TaskFile? file;
  final String docName;
  final String docType;
  final String notes;
  final String submittedBy;
  final DateTime? submittedAt;

  const TaskSubmission({
    required this.file,
    required this.docName,
    required this.docType,
    required this.notes,
    required this.submittedBy,
    required this.submittedAt,
  });

  factory TaskSubmission.fromDynamic(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return TaskSubmission(
        file: TaskFile.fromDynamic(map['file']),
        docName: _readString(map['docName']),
        docType: _readString(map['docType']),
        notes: _readString(map['notes']),
        submittedBy: _readString(map['submittedBy']),
        submittedAt: _readDate(map['submittedAt']),
      );
    }
    return const TaskSubmission(
      file: null,
      docName: '',
      docType: '',
      notes: '',
      submittedBy: '',
      submittedAt: null,
    );
  }
}

class TaskFile {
  final String publicId;
  final String url;
  final String format;
  final int size;

  const TaskFile({
    required this.publicId,
    required this.url,
    required this.format,
    required this.size,
  });

  factory TaskFile.fromDynamic(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return TaskFile(
        publicId: _readString(map['public_id']),
        url: _readString(map['url']),
        format: _readString(map['format']),
        size: _readInt(map['size']),
      );
    }
    return const TaskFile(
      publicId: '',
      url: '',
      format: '',
      size: 0,
    );
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

String _readId(Map<String, dynamic> json) {
  final candidates = [json['_id'], json['id']];
  for (final value in candidates) {
    final text = _readString(value);
    if (text.isNotEmpty) {
      return text;
    }
  }
  return '';
}
