class CreateTaskRequestModel {
  final String name;
  final String projectId;
  final String milestoneId;
  final String assignedTo;
  final String priority;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  const CreateTaskRequestModel({
    required this.name,
    required this.projectId,
    required this.milestoneId,
    required this.assignedTo,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'projectId': projectId,
      'milestoneId': milestoneId,
      'assignedTo': assignedTo,
      'priority': priority,
      'startDate': _formatDate(startDate),
      'endDate': _formatDate(endDate),
      'status': status,
    };
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
