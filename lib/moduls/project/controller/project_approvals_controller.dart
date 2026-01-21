import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_approvals_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProjectApprovalsController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<ClientGetApprovalsResponseModel> _approvals =
      <ClientGetApprovalsResponseModel>[];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ClientGetApprovalsResponseModel> get approvals => _approvals;

  Future<void> fetchApprovals() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await Get.find<ProjectInterface>().fetchClientApprovals();
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        _approvals = success.data ?? <ClientGetApprovalsResponseModel>[];
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isLoading = false;
    _errorMessage = '';
    _approvals = <ClientGetApprovalsResponseModel>[];
    super.dispose();
  }
}
