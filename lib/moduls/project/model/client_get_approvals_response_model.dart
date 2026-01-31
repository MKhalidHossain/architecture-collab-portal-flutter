class ClientGetApprovalsResponseModel {
  final String? id;
  final String? title;
  final String? projectId;
  final String? projectName;
  final String? description;
  final String? requestedBy;
  final DateTime? requestedDate;
  final DateTime? dueDate;
  final String? status;
  final String? fileUrl;

  ClientGetApprovalsResponseModel({
    this.id,
    this.title,
    this.projectId,
    this.projectName,
    this.description,
    this.requestedBy,
    this.requestedDate,
    this.dueDate,
    this.status,
    this.fileUrl,
  });

  factory ClientGetApprovalsResponseModel.fromJson(Map<String, dynamic> json) {
    return ClientGetApprovalsResponseModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      projectId: _readProjectId(json),
      projectName: json['projectName'] as String?,
      description: json['description'] as String?,
      requestedBy: json['requestedBy'] as String?,
      requestedDate: json['requestedDate'] != null
          ? DateTime.tryParse(json['requestedDate'].toString())
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'].toString())
          : null,
      status: json['status'] as String?,
      fileUrl: json['fileUrl'] as String?,
    );
  }

  static List<ClientGetApprovalsResponseModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .map(
            (e) => ClientGetApprovalsResponseModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }
    return <ClientGetApprovalsResponseModel>[];
  }
}

String? _readProjectId(Map<String, dynamic> json) {
  final direct = json['projectId']?.toString();
  if (direct != null && direct.isNotEmpty) {
    return direct;
  }
  final snake = json['project_id']?.toString();
  if (snake != null && snake.isNotEmpty) {
    return snake;
  }
  final project = json['project'];
  if (project is Map) {
    final map = Map<String, dynamic>.from(project);
    final nested = map['_id']?.toString() ?? map['id']?.toString();
    if (nested != null && nested.isNotEmpty) {
      return nested;
    }
  }
  return null;
}
