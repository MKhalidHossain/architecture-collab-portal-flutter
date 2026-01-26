class TeamPortalApprovalsResponse {
  final List<TeamApprovalTask> tasks;
  final List<TeamApprovalDocument> documents;

  const TeamPortalApprovalsResponse({
    required this.tasks,
    required this.documents,
  });

  factory TeamPortalApprovalsResponse.empty() {
    return const TeamPortalApprovalsResponse(
      tasks: <TeamApprovalTask>[],
      documents: <TeamApprovalDocument>[],
    );
  }

  factory TeamPortalApprovalsResponse.fromJson(Map<String, dynamic> json) {
    return TeamPortalApprovalsResponse(
      tasks: _readList(json['tasks'], (item) {
        return TeamApprovalTask.fromJson(item);
      }),
      documents: _readList(json['documents'], (item) {
        return TeamApprovalDocument.fromJson(item);
      }),
    );
  }
}

class TeamApprovalTask {
  final String id;
  final String name;
  final String status;
  final TeamApprovalProject project;
  final TeamApprovalSubmission submission;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TeamApprovalTask({
    required this.id,
    required this.name,
    required this.status,
    required this.project,
    required this.submission,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeamApprovalTask.fromJson(Map<String, dynamic> json) {
    return TeamApprovalTask(
      id: _readString(json['_id']),
      name: _readString(json['name']),
      status: _readString(json['status']),
      project: TeamApprovalProject.fromJson(_readMap(json['project'])),
      submission:
          TeamApprovalSubmission.fromJson(_readMap(json['submission'])),
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
    );
  }
}

class TeamApprovalSubmission {
  final TeamApprovalFile file;
  final String docName;
  final String docType;
  final String notes;
  final DateTime? submittedAt;

  const TeamApprovalSubmission({
    required this.file,
    required this.docName,
    required this.docType,
    required this.notes,
    required this.submittedAt,
  });

  factory TeamApprovalSubmission.fromJson(Map<String, dynamic> json) {
    return TeamApprovalSubmission(
      file: TeamApprovalFile.fromJson(_readMap(json['file'])),
      docName: _readString(json['docName']),
      docType: _readString(json['docType']),
      notes: _readString(json['notes']),
      submittedAt: _readDate(json['submittedAt']),
    );
  }
}

class TeamApprovalDocument {
  final String id;
  final String name;
  final String status;
  final String notes;
  final TeamApprovalProject project;
  final TeamApprovalFile file;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? approvedDate;

  const TeamApprovalDocument({
    required this.id,
    required this.name,
    required this.status,
    required this.notes,
    required this.project,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
    required this.approvedDate,
  });

  factory TeamApprovalDocument.fromJson(Map<String, dynamic> json) {
    return TeamApprovalDocument(
      id: _readString(json['_id']),
      name: _readString(json['name']),
      status: _readString(json['status']),
      notes: _readString(json['notes']),
      project: TeamApprovalProject.fromJson(_readMap(json['project'])),
      file: TeamApprovalFile.fromJson(_readMap(json['file'])),
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
      approvedDate: _readDate(json['approvedDate']),
    );
  }
}

class TeamApprovalProject {
  final String id;
  final String name;

  const TeamApprovalProject({
    required this.id,
    required this.name,
  });

  factory TeamApprovalProject.fromJson(Map<String, dynamic> json) {
    return TeamApprovalProject(
      id: _readString(json['_id']),
      name: _readString(json['name']),
    );
  }
}

class TeamApprovalFile {
  final String url;
  final String format;
  final int size;

  const TeamApprovalFile({
    required this.url,
    required this.format,
    required this.size,
  });

  factory TeamApprovalFile.fromJson(Map<String, dynamic> json) {
    return TeamApprovalFile(
      url: _readString(json['url']),
      format: _readString(json['format']),
      size: _readInt(json['size']),
    );
  }
}

class TeamApprovalItem {
  final String id;
  final String title;
  final String description;
  final String status;
  final String projectName;
  final String requestedBy;
  final DateTime? requestedDate;
  final DateTime? approvedDate;

  const TeamApprovalItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.projectName,
    required this.requestedBy,
    required this.requestedDate,
    required this.approvedDate,
  });
}

String _readString(dynamic value) => value?.toString() ?? '';

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? _readDate(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }
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
