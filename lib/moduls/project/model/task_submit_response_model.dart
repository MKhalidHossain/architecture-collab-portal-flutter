import 'package:dana_bozzetto/moduls/project/model/project_task_response_model.dart';

class TaskSubmitResponseModel {
  final String message;
  final ProjectTaskResponseModel task;

  const TaskSubmitResponseModel({
    required this.message,
    required this.task,
  });

  factory TaskSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    final message = json['message']?.toString() ?? '';
    final taskMap = json['task'] is Map
        ? Map<String, dynamic>.from(json['task'])
        : <String, dynamic>{};
    return TaskSubmitResponseModel(
      message: message,
      task: ProjectTaskResponseModel.fromJson(taskMap),
    );
  }
}
