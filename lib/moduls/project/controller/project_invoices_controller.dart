import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/project_finance_item.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProjectInvoicesController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<ProjectFinanceItem> _finances = <ProjectFinanceItem>[];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ProjectFinanceItem> get finances => _finances;

  Future<void> fetchFinances() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await Get.find<ProjectInterface>().fetchFinances();
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        _finances = success.data ?? <ProjectFinanceItem>[];
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isLoading = false;
    _errorMessage = '';
    _finances = <ProjectFinanceItem>[];
    super.dispose();
  }
}
