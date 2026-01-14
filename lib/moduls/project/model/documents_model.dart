class DocumentModel {
  final String category;
  final String? title;
  final String? subtitle;
  final String size;
  final String date;
  final String type;

  DocumentModel({
    required this.category,
    this.title,
    this.subtitle,
    required this.size,
    required this.date,
    required this.type,
  });
}
