class ClientGetDocumentsResponseModel {
  String? id;
  String? name;
  String? projectName;
  String? milestoneName;
  String? type;
  int? size;
  String? url;
  String? uploadedBy;
  DateTime? uploadedDate;
  String? status;
  int? commentsCount;

  ClientGetDocumentsResponseModel({
    this.id,
    this.name,
    this.projectName,
    this.milestoneName,
    this.type,
    this.size,
    this.url,
    this.uploadedBy,
    this.uploadedDate,
    this.status,
    this.commentsCount,
  });

  factory ClientGetDocumentsResponseModel.empty() {
    return ClientGetDocumentsResponseModel();
  }

  factory ClientGetDocumentsResponseModel.fromJson(Map<String, dynamic> json) {
    return ClientGetDocumentsResponseModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      projectName: json['projectName'] as String?,
      milestoneName: json['milestoneName'] as String?,
      type: json['type'] as String?,
      size: (json['size'] as num?)?.toInt(),
      url: json['url'] as String?,
      uploadedBy: json['uploadedBy'] as String?,
      uploadedDate: json['uploadedDate'] != null
          ? DateTime.tryParse(json['uploadedDate'].toString())
          : null,
      status: json['status'] as String?,
      commentsCount: (json['commentsCount'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'projectName': projectName,
      'milestoneName': milestoneName,
      'type': type,
      'size': size,
      'url': url,
      'uploadedBy': uploadedBy,
      'uploadedDate': uploadedDate?.toIso8601String(),
      'status': status,
      'commentsCount': commentsCount,
    };
  }

  /// ✅ Parse API response that is a LIST:  [ { ... }, { ... } ]
  static List<ClientGetDocumentsResponseModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .map((e) => ClientGetDocumentsResponseModel.fromJson(
              e as Map<String, dynamic>))
          .toList();
    }
    return <ClientGetDocumentsResponseModel>[];
  }
}
