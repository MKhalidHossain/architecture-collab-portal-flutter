class ProjectModel {
  final String id;
  final String image;
  final String status;
  final bool isActive;
  final List<ProjectStep> steps;
  final String title;
  final String subtitle;
  final DateTime deadline;
  final int currentMilestone;
  final int totalMilestones;
  final List<String> teamAvatars;

  ProjectModel({
    required this.id,
    required this.image,
    required this.status,
    required this.isActive,
    required this.steps,
    required this.title,
    required this.subtitle,
    required this.deadline,
    required this.currentMilestone,
    required this.totalMilestones,
    required this.teamAvatars,
  });
}


class ProjectStep {
  final String label;
  final bool completed;

  ProjectStep({
    required this.label,
    required this.completed,
  });
}
