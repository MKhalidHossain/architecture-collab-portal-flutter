import 'projects_response_model.dart';

class ProjectDetailsResponse {
  final ProjectDetailsModel project;

  const ProjectDetailsResponse({required this.project});

  factory ProjectDetailsResponse.empty() {
    return ProjectDetailsResponse(project: ProjectDetailsModel.empty());
  }

  factory ProjectDetailsResponse.fromJson(dynamic json) {
    dynamic payload = json;
    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);
      final nested = map['data'];
      if (nested is Map) {
        payload =
            nested['project'] ?? nested['item'] ?? nested['data'] ?? nested;
      } else {
        payload = nested ?? map['project'] ?? map['item'] ?? map;
      }
    }
    if (payload is Map) {
      return ProjectDetailsResponse(
        project: ProjectDetailsModel.fromJson(
          Map<String, dynamic>.from(payload),
        ),
      );
    }
    return ProjectDetailsResponse.empty();
  }
}

class ProjectDetailsModel {
  final String id;
  final String projectNo;
  final String name;
  final String type;
  final String location;
  final ProjectClient client;
  final List<ProjectTeamMember> teamMembers;
  final String status;
  final int budget;
  final int totalPaid;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ProjectMilestone> milestones;
  final int overallProgress;
  final ProjectImage coverImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> tasks;
  final List<dynamic> documents;
  final ProjectFinancials financials;

  const ProjectDetailsModel({
    required this.id,
    required this.projectNo,
    required this.name,
    required this.type,
    required this.location,
    required this.client,
    required this.teamMembers,
    required this.status,
    required this.budget,
    required this.totalPaid,
    required this.startDate,
    required this.endDate,
    required this.milestones,
    required this.overallProgress,
    required this.coverImage,
    required this.createdAt,
    required this.updatedAt,
    required this.tasks,
    required this.documents,
    required this.financials,
  });

  factory ProjectDetailsModel.empty() {
    return ProjectDetailsModel(
      id: '',
      projectNo: '',
      name: '',
      type: '',
      location: '',
      client: const ProjectClient(
        id: '',
        name: '',
        email: '',
        avatar: ProjectImage(publicId: '', url: ''),
      ),
      teamMembers: const <ProjectTeamMember>[],
      status: '',
      budget: 0,
      totalPaid: 0,
      startDate: null,
      endDate: null,
      milestones: const <ProjectMilestone>[],
      overallProgress: 0,
      coverImage: const ProjectImage(publicId: '', url: ''),
      createdAt: null,
      updatedAt: null,
      tasks: const <dynamic>[],
      documents: const <dynamic>[],
      financials: const ProjectFinancials(
        totalBudget: 0,
        totalPaid: 0,
        totalUnpaid: 0,
      ),
    );
  }

  factory ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    final budget = _readInt(json['budget']);
    final paid = _readInt(json['totalPaid']);
    final financialsMap = _readMap(json['financials']);
    final financials = financialsMap.isNotEmpty
        ? ProjectFinancials.fromJson(financialsMap)
        : ProjectFinancials(
            totalBudget: budget,
            totalPaid: paid,
            totalUnpaid: budget > paid ? budget - paid : 0,
          );

    return ProjectDetailsModel(
      id: _readId(json),
      projectNo: _readString(json['projectNo']),
      name: _readString(json['name']),
      type: _readString(json['type']).isNotEmpty
          ? _readString(json['type'])
          : _readString(json['projectType']),
      location: _readString(json['location']).isNotEmpty
          ? _readString(json['location'])
          : _readString(json['address']),
      client: ProjectClient.fromJson(_readMap(json['client'])),
      teamMembers: _readList(json['teamMembers'], (item) {
        return ProjectTeamMember.fromJson(item);
      }),
      status: _readString(json['status']),
      budget: budget,
      totalPaid: paid,
      startDate: _readDate(json['startDate']),
      endDate: _readDate(json['endDate']),
      milestones: _readList(json['milestones'], (item) {
        return ProjectMilestone.fromJson(item);
      }),
      overallProgress: _readInt(json['overallProgress']),
      coverImage: ProjectImage.fromDynamic(json['coverImage']),
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
      tasks: _readDynamicList(json['tasks']),
      documents: _readDynamicList(json['documents']),
      financials: financials,
    );
  }
}

class ProjectFinancials {
  final int totalBudget;
  final int totalPaid;
  final int totalUnpaid;

  const ProjectFinancials({
    required this.totalBudget,
    required this.totalPaid,
    required this.totalUnpaid,
  });

  factory ProjectFinancials.fromJson(Map<String, dynamic> json) {
    return ProjectFinancials(
      totalBudget: _readInt(json['totalBudget']),
      totalPaid: _readInt(json['totalPaid']),
      totalUnpaid: _readInt(json['totalUnpaid']),
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
  final candidates = [
    json['_id'],
    json['id'],
  ];
  for (final value in candidates) {
    final text = _readString(value);
    if (text.isNotEmpty) {
      return text;
    }
  }
  return '';
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

List<dynamic> _readDynamicList(dynamic value) {
  if (value is! List) return <dynamic>[];
  return List<dynamic>.from(value);
}
