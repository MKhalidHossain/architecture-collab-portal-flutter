class ProjectDocumentFile {
  final String? publicId;
  final String? url;
  final String? mimeType;
  final int? size;
  final String? format;

  const ProjectDocumentFile({
    this.publicId,
    this.url,
    this.mimeType,
    this.size,
    this.format,
  });

  factory ProjectDocumentFile.fromJson(Map<String, dynamic> json) {
    return ProjectDocumentFile(
      publicId: json['public_id'] as String?,
      url: json['url'] as String?,
      mimeType: json['mimeType'] as String?,
      size: (json['size'] as num?)?.toInt(),
      format: json['format'] as String?,
    );
  }
}

class ProjectDocumentAvatar {
  final String? publicId;
  final String? url;

  const ProjectDocumentAvatar({
    this.publicId,
    this.url,
  });

  factory ProjectDocumentAvatar.fromJson(Map<String, dynamic> json) {
    return ProjectDocumentAvatar(
      publicId: json['public_id'] as String?,
      url: json['url'] as String?,
    );
  }
}

class ProjectDocumentUser {
  final ProjectDocumentAvatar? avatar;
  final String? id;
  final String? name;
  final String? role;

  const ProjectDocumentUser({
    this.avatar,
    this.id,
    this.name,
    this.role,
  });

  factory ProjectDocumentUser.fromJson(Map<String, dynamic> json) {
    return ProjectDocumentUser(
      avatar: json['avatar'] is Map<String, dynamic>
          ? ProjectDocumentAvatar.fromJson(
              json['avatar'] as Map<String, dynamic>,
            )
          : null,
      id: json['_id'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?,
    );
  }
}

class ProjectDocumentComment {
  final String? user;
  final String? text;
  final DateTime? createdAt;
  final String? id;

  const ProjectDocumentComment({
    this.user,
    this.text,
    this.createdAt,
    this.id,
  });

  factory ProjectDocumentComment.fromJson(Map<String, dynamic> json) {
    return ProjectDocumentComment(
      user: json['user'] as String?,
      text: json['text'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      id: json['_id'] as String?,
    );
  }
}

class ProjectDocumentsResponseModel {
  final ProjectDocumentFile? file;
  final String? id;
  final String? name;
  final String? project;
  final String? milestoneId;
  final ProjectDocumentUser? uploadedBy;
  final String? type;
  final int? version;
  final String? notes;
  final String? status;
  final List<ProjectDocumentComment> comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? approvedBy;
  final DateTime? approvedDate;

  const ProjectDocumentsResponseModel({
    this.file,
    this.id,
    this.name,
    this.project,
    this.milestoneId,
    this.uploadedBy,
    this.type,
    this.version,
    this.notes,
    this.status,
    this.comments = const <ProjectDocumentComment>[],
    this.createdAt,
    this.updatedAt,
    this.v,
    this.approvedBy,
    this.approvedDate,
  });

  factory ProjectDocumentsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProjectDocumentsResponseModel(
      file: json['file'] is Map<String, dynamic>
          ? ProjectDocumentFile.fromJson(json['file'] as Map<String, dynamic>)
          : null,
      id: json['_id'] as String?,
      name: json['name'] as String?,
      project: json['project'] as String?,
      milestoneId: json['milestoneId'] as String?,
      uploadedBy: json['uploadedBy'] is Map<String, dynamic>
          ? ProjectDocumentUser.fromJson(
              json['uploadedBy'] as Map<String, dynamic>,
            )
          : null,
      type: json['type'] as String?,
      version: (json['version'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      comments: json['comments'] is List
          ? (json['comments'] as List)
              .whereType<Map>()
              .map((comment) => ProjectDocumentComment.fromJson(
                    Map<String, dynamic>.from(comment),
                  ))
              .toList()
          : const <ProjectDocumentComment>[],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      v: (json['__v'] as num?)?.toInt(),
      approvedBy: json['approvedBy'] as String?,
      approvedDate: json['approvedDate'] != null
          ? DateTime.tryParse(json['approvedDate'].toString())
          : null,
    );
  }

  static List<ProjectDocumentsResponseModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .whereType<Map>()
          .map(
            (item) => ProjectDocumentsResponseModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }
    return <ProjectDocumentsResponseModel>[];
  }
}
