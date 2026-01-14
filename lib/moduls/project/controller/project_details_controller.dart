import 'package:dana_bozzetto/moduls/project/model/client_get_documents_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../interface/project_interface.dart';
import '../model/project_details_response_model.dart';

class ProjectDetailsController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  ProjectDetailsResponse _details = ProjectDetailsResponse.empty();
  List<ClientGetDocumentsResponseModel> _documents = <ClientGetDocumentsResponseModel>[];
  

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  ProjectDetailsResponse get details => _details;
  List<ClientGetDocumentsResponseModel> get documents => _documents;

  Future<void> fetchProjectDetails(String projectId) async {
    if (projectId.trim().isEmpty) {
      _errorMessage = 'Project ID is missing.';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await Get.find<ProjectInterface>()
        .fetchProjectDetails(projectId: projectId);
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        _details = success.data ?? ProjectDetailsResponse.empty();
      },
    );

    _isLoading = false;
    notifyListeners();
  } 
  
  
   Future<void> getClientDocuments() async {

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await Get.find<ProjectInterface>()
        .fetchClientDocuments();
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        _documents = success.data ?? <ClientGetDocumentsResponseModel>[];
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isLoading = false;
    _errorMessage = '';
    _details = ProjectDetailsResponse.empty();
    _documents = <ClientGetDocumentsResponseModel>[];
    super.dispose();
  }
}
