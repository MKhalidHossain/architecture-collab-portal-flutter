import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/project_task_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProjectTasksController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<ProjectTaskResponseModel> _tasks = <ProjectTaskResponseModel>[];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ProjectTaskResponseModel> get tasks => _tasks;

  Future<void> fetchTasks({required String projectId}) async {
    if (projectId.trim().isEmpty) {
      _errorMessage = 'Project ID is missing.';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result =
        await Get.find<ProjectInterface>().fetchProjectTasks(
          projectId: projectId,
        );
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        _tasks = success.data ?? <ProjectTaskResponseModel>[];
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isLoading = false;
    _errorMessage = '';
    _tasks = <ProjectTaskResponseModel>[];
    super.dispose();
  }
}
