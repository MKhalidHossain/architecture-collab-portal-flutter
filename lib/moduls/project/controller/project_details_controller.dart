import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/team_member_get_documents_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../interface/project_interface.dart';
import '../model/project_details_response_model.dart';

class ProjectDetailsController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  ProjectDetailsResponse _details = ProjectDetailsResponse.empty();
  AuthRole _authRole = AuthRole.unknown;
  List<ClientGetDocumentsResponseModel> _clientDocuments =
      <ClientGetDocumentsResponseModel>[];
  List<TeamMemberGetDocumentsResponseModel> _teamMemberDocuments =
      <TeamMemberGetDocumentsResponseModel>[];
  

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  ProjectDetailsResponse get details => _details;
  AuthRole get authRole => _authRole;
  List<ClientGetDocumentsResponseModel> get clientDocuments =>
      _clientDocuments;
  List<TeamMemberGetDocumentsResponseModel> get teamMemberDocuments =>
      _teamMemberDocuments;

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
  
  
  Future<void> getDocuments() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final authStatus = await Get.find<AppPigeon>().currentAuth();
    if (authStatus is Authenticated) {
      _authRole = authStatus.auth.authRole;
    } else {
      _authRole = AuthRole.unknown;
    }

    if (_authRole == AuthRole.teamMember) {
      final result =
          await Get.find<ProjectInterface>().fetchTeamMemberDocuments();
      result.fold(
        (failure) {
          _errorMessage = failure.uiMessage.isNotEmpty
              ? failure.uiMessage
              : failure.fullError;
        },
        (success) {
          _teamMemberDocuments =
              success.data ?? <TeamMemberGetDocumentsResponseModel>[];
          _clientDocuments = <ClientGetDocumentsResponseModel>[];
        },
      );
    } else if (_authRole == AuthRole.client) {
      final result = await Get.find<ProjectInterface>().fetchClientDocuments();
      result.fold(
        (failure) {
          _errorMessage = failure.uiMessage.isNotEmpty
              ? failure.uiMessage
              : failure.fullError;
        },
        (success) {
          _clientDocuments =
              success.data ?? <ClientGetDocumentsResponseModel>[];
          _teamMemberDocuments = <TeamMemberGetDocumentsResponseModel>[];
        },
      );
    } else {
      _errorMessage = 'Unable to detect user role.';
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isLoading = false;
    _errorMessage = '';
    _details = ProjectDetailsResponse.empty();
    _authRole = AuthRole.unknown;
    _clientDocuments = <ClientGetDocumentsResponseModel>[];
    _teamMemberDocuments = <TeamMemberGetDocumentsResponseModel>[];
    super.dispose();
  }
}
