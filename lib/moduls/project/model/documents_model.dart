class DocumentModel {
  final String category;
  final String? title;
  final String? subtitle;
  final String size;
  final String date;
  final String type;
  final String? status;
  final String? uploadedBy;
  final int? commentsCount;
  final String? url;

  DocumentModel({
    required this.category,
    this.title,
    this.subtitle,
    required this.size,
    required this.date,
    required this.type,
    this.status,
    this.uploadedBy,
    this.commentsCount,
    this.url,
  });
}
