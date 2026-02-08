import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_approvals_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/team_portal_approvals_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProjectApprovalsController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<ClientGetApprovalsResponseModel> _approvals =
      <ClientGetApprovalsResponseModel>[];
  List<TeamApprovalItem> _teamApprovals = <TeamApprovalItem>[];
  AuthRole _authRole = AuthRole.unknown;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ClientGetApprovalsResponseModel> get approvals => _approvals;
  List<TeamApprovalItem> get teamApprovals => _teamApprovals;
  AuthRole get authRole => _authRole;

  Future<void> fetchApprovals() async {
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
      final result = await Get.find<ProjectInterface>().fetchTeamApprovals();
      result.fold(
        (failure) {
          _errorMessage = failure.uiMessage.isNotEmpty
              ? failure.uiMessage
              : failure.fullError;
        },
        (success) {
          final data = success.data ?? TeamPortalApprovalsResponse.empty();
          _teamApprovals = _buildTeamApprovals(data);
          _approvals = <ClientGetApprovalsResponseModel>[];
        },
      );
    } else {
      final result = await Get.find<ProjectInterface>().fetchClientApprovals();
      result.fold(
        (failure) {
          _errorMessage = failure.uiMessage.isNotEmpty
              ? failure.uiMessage
              : failure.fullError;
        },
        (success) {
          _approvals = success.data ?? <ClientGetApprovalsResponseModel>[];
          _teamApprovals = <TeamApprovalItem>[];
        },
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  List<TeamApprovalItem> _buildTeamApprovals(
    TeamPortalApprovalsResponse response,
  ) {
    final items = <TeamApprovalItem>[];
    for (final task in response.tasks) {
      final title = task.submission.docName.isNotEmpty
          ? task.submission.docName
          : task.name;
      final description = task.submission.notes.isNotEmpty
          ? task.submission.notes
          : (task.name.isNotEmpty ? task.name : 'Approval request');
      items.add(
        TeamApprovalItem(
          id: task.id,
          title: title,
          description: description,
          status: task.status,
          projectId: task.project.id,
          projectName: task.project.name,
          requestedBy: '',
          requestedDate: task.submission.submittedAt ?? task.createdAt,
          approvedDate: task.updatedAt,
        ),
      );
    }
    for (final doc in response.documents) {
      items.add(
        TeamApprovalItem(
          id: doc.id,
          title: doc.name,
          description: doc.notes.isNotEmpty
              ? doc.notes
              : 'Please review and approve the document.',
          status: doc.status,
          projectId: doc.project.id,
          projectName: doc.project.name,
          requestedBy: '',
          requestedDate: doc.createdAt,
          approvedDate: doc.approvedDate ?? doc.updatedAt,
        ),
      );
    }
    items.sort((a, b) {
      final aDate = a.requestedDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.requestedDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return items;
  }

  @override
  void dispose() {
    _isLoading = false;
    _errorMessage = '';
    _approvals = <ClientGetApprovalsResponseModel>[];
    _teamApprovals = <TeamApprovalItem>[];
    _authRole = AuthRole.unknown;
    super.dispose();
  }
}
