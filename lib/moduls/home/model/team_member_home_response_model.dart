class TeamMemberDashboardResponse {
  final String userName;
  final List<Map<String, dynamic>> todayTasks;
  final TeamMemberStats stats;
  final TeamMemberQuickActions quickActions;
  final List<TeamMemberProject> assignedProjects;
  final List<Map<String, dynamic>> recentMessages;

  const TeamMemberDashboardResponse({
    required this.userName,
    required this.todayTasks,
    required this.stats,
    required this.quickActions,
    required this.assignedProjects,
    required this.recentMessages,
  });

  factory TeamMemberDashboardResponse.empty() {
    return const TeamMemberDashboardResponse(
      userName: '',
      todayTasks: <Map<String, dynamic>>[],
      stats: TeamMemberStats.empty(),
      quickActions: TeamMemberQuickActions.empty(),
      assignedProjects: <TeamMemberProject>[],
      recentMessages: <Map<String, dynamic>>[],
    );
  }

  factory TeamMemberDashboardResponse.fromJson(Map<String, dynamic> json) {
    return TeamMemberDashboardResponse(
      userName: _readString(json['userName']),
      todayTasks: _readMapList(json['todayTasks']),
      stats: TeamMemberStats.fromJson(_readMap(json['stats'])),
      quickActions:
          TeamMemberQuickActions.fromJson(_readMap(json['quickActions'])),
      assignedProjects: _readList(json['assignedProjects'], (item) {
        return TeamMemberProject.fromJson(item);
      }),
      recentMessages: _readMapList(json['recentMessages']),
    );
  }
}

class TeamMemberStats {
  final int activeTasks;
  final int pendingTasks;

  const TeamMemberStats({
    required this.activeTasks,
    required this.pendingTasks,
  });

  const TeamMemberStats.empty()
      : activeTasks = 0,
        pendingTasks = 0;

  factory TeamMemberStats.fromJson(Map<String, dynamic> json) {
    return TeamMemberStats(
      activeTasks: _readInt(json['activeTasks']),
      pendingTasks: _readInt(json['pendingTasks']),
    );
  }
}

class TeamMemberQuickActions {
  final int documents;
  final int approvals;
  final int reviews;

  const TeamMemberQuickActions({
    required this.documents,
    required this.approvals,
    required this.reviews,
  });

  const TeamMemberQuickActions.empty()
      : documents = 0,
        approvals = 0,
        reviews = 0;

  factory TeamMemberQuickActions.fromJson(Map<String, dynamic> json) {
    return TeamMemberQuickActions(
      documents: _readInt(json['documents']),
      approvals: _readInt(json['approvals']),
      reviews: _readInt(json['reviews']),
    );
  }
}

class TeamMemberProject {
  final String id;
  final String name;
  final String clientName;
  final String status;
  final DateTime? deadline;
  final String coverImage;
  final String milestoneProgress;
  final int overallProgress;
  final List<String> teamAvatars;

  const TeamMemberProject({
    required this.id,
    required this.name,
    required this.clientName,
    required this.status,
    required this.deadline,
    required this.coverImage,
    required this.milestoneProgress,
    required this.overallProgress,
    required this.teamAvatars,
  });

  factory TeamMemberProject.fromJson(Map<String, dynamic> json) {
    return TeamMemberProject(
      id: _readString(json['_id']),
      name: _readString(json['name']),
      clientName: _readString(json['clientName']),
      status: _readString(json['status']),
      deadline: _readDate(json['deadline']),
      coverImage: _readString(json['coverImage']),
      milestoneProgress: _readString(json['milestoneProgress']),
      overallProgress: _readInt(json['overallProgress']),
      teamAvatars: _readStringList(json['teamAvatars']),
    );
  }

  int get milestoneCurrent {
    final parts = milestoneProgress.split('/');
    if (parts.isEmpty) return 0;
    return _readInt(parts.first);
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

List<Map<String, dynamic>> _readMapList(dynamic value) {
  if (value is! List) return <Map<String, dynamic>>[];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

List<String> _readStringList(dynamic value) {
  if (value is! List) return <String>[];
  return value.map((item) => item?.toString() ?? '').toList();
}
