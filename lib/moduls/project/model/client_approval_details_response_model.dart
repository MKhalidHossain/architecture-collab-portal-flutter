class ClientApprovalFileModel {
  final String? publicId;
  final String? url;
  final String? mimeType;
  final int? size;
  final String? format;

  const ClientApprovalFileModel({
    this.publicId,
    this.url,
    this.mimeType,
    this.size,
    this.format,
  });

  factory ClientApprovalFileModel.fromJson(Map<String, dynamic> json) {
    return ClientApprovalFileModel(
      publicId: json['public_id'] as String?,
      url: json['url'] as String?,
      mimeType: json['mimeType'] as String?,
      size: (json['size'] as num?)?.toInt(),
      format: json['format'] as String?,
    );
  }
}

class ClientApprovalDocumentModel {
  final ClientApprovalFileModel? file;
  final String? id;
  final String? name;
  final String? project;
  final String? milestoneId;
  final String? uploadedBy;
  final String? type;
  final int? version;
  final List<dynamic> comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const ClientApprovalDocumentModel({
    this.file,
    this.id,
    this.name,
    this.project,
    this.milestoneId,
    this.uploadedBy,
    this.type,
    this.version,
    this.comments = const <dynamic>[],
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ClientApprovalDocumentModel.fromJson(Map<String, dynamic> json) {
    return ClientApprovalDocumentModel(
      file: json['file'] is Map<String, dynamic>
          ? ClientApprovalFileModel.fromJson(
              json['file'] as Map<String, dynamic>,
            )
          : null,
      id: json['_id'] as String?,
      name: json['name'] as String?,
      project: json['project'] as String?,
      milestoneId: json['milestoneId'] as String?,
      uploadedBy: json['uploadedBy'] as String?,
      type: json['type'] as String?,
      version: (json['version'] as num?)?.toInt(),
      comments: json['comments'] is List
          ? List<dynamic>.from(json['comments'] as List)
          : const <dynamic>[],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      v: (json['__v'] as num?)?.toInt(),
    );
  }
}

class ClientApprovalDetailsResponseModel {
  final String? message;
  final ClientApprovalDocumentModel? document;

  const ClientApprovalDetailsResponseModel({
    this.message,
    this.document,
  });

  factory ClientApprovalDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClientApprovalDetailsResponseModel(
      message: json['message'] as String?,
      document: json['document'] is Map<String, dynamic>
          ? ClientApprovalDocumentModel.fromJson(
              json['document'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
