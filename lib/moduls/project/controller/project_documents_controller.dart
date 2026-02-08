import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/project_documents_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProjectDocumentsController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<ProjectDocumentsResponseModel> _documents =
      <ProjectDocumentsResponseModel>[];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ProjectDocumentsResponseModel> get documents => _documents;

  Future<void> fetchProjectDocuments(String projectId) async {
    if (projectId.trim().isEmpty) {
      _errorMessage = 'Project ID is missing.';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await Get.find<ProjectInterface>()
        .fetchProjectDocuments(projectId: projectId);
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        _documents = success.data ?? <ProjectDocumentsResponseModel>[];
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isLoading = false;
    _errorMessage = '';
    _documents = <ProjectDocumentsResponseModel>[];
    super.dispose();
  }
}
