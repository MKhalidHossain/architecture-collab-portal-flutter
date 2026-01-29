class SearchResponse {
  final List<SearchProject> projects;
  final List<SearchDocument> documents;
  final List<SearchInvoice> invoices;

  const SearchResponse({
    required this.projects,
    required this.documents,
    required this.invoices,
  });

  factory SearchResponse.empty() {
    return const SearchResponse(
      projects: <SearchProject>[],
      documents: <SearchDocument>[],
      invoices: <SearchInvoice>[],
    );
  }

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      projects: _readList(json['projects'], (item) {
        return SearchProject.fromJson(item);
      }),
      documents: _readList(json['documents'], (item) {
        return SearchDocument.fromJson(item);
      }),
      invoices: _readList(json['invoices'], (item) {
        return SearchInvoice.fromJson(item);
      }),
    );
  }

  bool get isEmpty =>
      projects.isEmpty && documents.isEmpty && invoices.isEmpty;
}

class SearchProject {
  final String id;
  final String name;
  final String status;
  final String image;

  const SearchProject({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
  });

  factory SearchProject.fromJson(Map<String, dynamic> json) {
    return SearchProject(
      id: _readString(json['_id']),
      name: _readString(json['name']),
      status: _readString(json['status']),
      image: _readString(json['image']),
    );
  }
}

class SearchDocument {
  final String id;
  final String name;
  final String type;
  final String fileUrl;
  final String projectName;

  const SearchDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.fileUrl,
    required this.projectName,
  });

  factory SearchDocument.fromJson(Map<String, dynamic> json) {
    final file = _readMap(json['file']);
    final project = _readMap(json['project']);
    final projectName = _readFirstString(
      json,
      const ['projectName', 'project_name'],
    );
    return SearchDocument(
      id: _readString(json['_id']),
      name: _readString(json['name']),
      type: _readString(json['type']),
      fileUrl: _readString(file['url']),
      projectName:
          projectName.isNotEmpty ? projectName : _readString(project['name']),
    );
  }
}

class SearchInvoice {
  final String id;
  final String title;
  final String status;
  final String fileUrl;
  final String projectName;
  final String projectId;

  const SearchInvoice({
    required this.id,
    required this.title,
    required this.status,
    required this.fileUrl,
    required this.projectName,
    required this.projectId,
  });

  factory SearchInvoice.fromJson(Map<String, dynamic> json) {
    final file = _readMap(json['file']);
    final project = _readMap(json['project']);
    final projectName = _readFirstString(
      json,
      const ['projectName', 'project_name'],
    );
    return SearchInvoice(
      id: _readString(json['_id']),
      title: _readFirstString(
        json,
        const ['customId', 'name', 'title', 'invoiceNumber'],
      ),
      status: _readString(json['status']),
      fileUrl: _readString(file['url']),
      projectName:
          projectName.isNotEmpty ? projectName : _readString(project['name']),
      projectId: _readProjectId(json),
    );
  }
}

String _readProjectId(Map<String, dynamic> json) {
  final direct = _readString(json['projectId']);
  if (direct.isNotEmpty) {
    return direct;
  }
  final project = _readMap(json['project']);
  final nested = _readString(project['_id']).isNotEmpty
      ? _readString(project['_id'])
      : _readString(project['id']);
  return nested;
}

String _readString(dynamic value) => value?.toString() ?? '';

Map<String, dynamic> _readMap(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
}

String _readFirstString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _readString(json[key]);
    if (value.isNotEmpty) {
      return value;
    }
  }
  return _readString(json['_id']);
}

List<T> _readList<T>(dynamic value, T Function(Map<String, dynamic>) parse) {
  if (value is! List) return <T>[];
  return value
      .whereType<Map>()
      .map((item) => parse(Map<String, dynamic>.from(item)))
      .toList();
}
