class TeamMemberDocumentFile {
  final String? publicId;
  final String? url;
  final String? mimeType;
  final int? size;
  final String? format;

  TeamMemberDocumentFile({
    this.publicId,
    this.url,
    this.mimeType,
    this.size,
    this.format,
  });

  factory TeamMemberDocumentFile.fromJson(Map<String, dynamic> json) {
    return TeamMemberDocumentFile(
      publicId: json['public_id'] as String?,
      url: json['url'] as String?,
      mimeType: json['mimeType'] as String?,
      size: (json['size'] as num?)?.toInt(),
      format: json['format'] as String?,
    );
  }
}

class TeamMemberDocumentProject {
  final String? id;
  final String? name;
  final String? projectId;

  TeamMemberDocumentProject({
    this.id,
    this.name,
    this.projectId,
  });

  factory TeamMemberDocumentProject.fromJson(Map<String, dynamic> json) {
    return TeamMemberDocumentProject(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      projectId: json['id'] as String?,
    );
  }
}

class TeamMemberDocumentUser {
  final String? id;
  final String? name;

  TeamMemberDocumentUser({
    this.id,
    this.name,
  });

  factory TeamMemberDocumentUser.fromJson(Map<String, dynamic> json) {
    return TeamMemberDocumentUser(
      id: json['_id'] as String?,
      name: json['name'] as String?,
    );
  }
}

class TeamMemberGetDocumentsResponseModel {
  final String? id;
  final TeamMemberDocumentFile? file;
  final String? name;
  final TeamMemberDocumentProject? project;
  final String? milestoneId;
  final TeamMemberDocumentUser? uploadedBy;
  final String? type;
  final int? version;
  final String? notes;
  final String? status;
  final List<dynamic> comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? approvedBy;
  final DateTime? approvedDate;

  TeamMemberGetDocumentsResponseModel({
    this.id,
    this.file,
    this.name,
    this.project,
    this.milestoneId,
    this.uploadedBy,
    this.type,
    this.version,
    this.notes,
    this.status,
    this.comments = const <dynamic>[],
    this.createdAt,
    this.updatedAt,
    this.approvedBy,
    this.approvedDate,
  });

  factory TeamMemberGetDocumentsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeamMemberGetDocumentsResponseModel(
      id: json['_id'] as String?,
      file: json['file'] is Map<String, dynamic>
          ? TeamMemberDocumentFile.fromJson(
              json['file'] as Map<String, dynamic>,
            )
          : null,
      name: json['name'] as String?,
      project: json['project'] is Map<String, dynamic>
          ? TeamMemberDocumentProject.fromJson(
              json['project'] as Map<String, dynamic>,
            )
          : null,
      milestoneId: json['milestoneId'] as String?,
      uploadedBy: json['uploadedBy'] is Map<String, dynamic>
          ? TeamMemberDocumentUser.fromJson(
              json['uploadedBy'] as Map<String, dynamic>,
            )
          : null,
      type: json['type'] as String?,
      version: (json['version'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      comments: json['comments'] is List
          ? List<dynamic>.from(json['comments'] as List)
          : const <dynamic>[],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      approvedBy: json['approvedBy'] as String?,
      approvedDate: json['approvedDate'] != null
          ? DateTime.tryParse(json['approvedDate'].toString())
          : null,
    );
  }

  static List<TeamMemberGetDocumentsResponseModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .map(
            (e) => TeamMemberGetDocumentsResponseModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }
    return <TeamMemberGetDocumentsResponseModel>[];
  }
}
