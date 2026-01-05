import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../interface/auth_interface.dart';
import '../../profile/model/update_profile_request_model.dart';

class UpdateProfileController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: EnabledStatus());
  final SnackbarNotifier snackbarNotifier;

  UpdateProfileController(this.snackbarNotifier);

  Future<bool> updateProfile({
    required UpdateProfileRequestModel param,
  }) async {
    processStatusNotifier.setLoading();
    final result = await Get.find<AuthInterface>().updateProfile(param: param);
    var isSuccess = false;
    handleFold(
      either: result,
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccess: (_) {
        isSuccess = true;
      },
    );
    return isSuccess;
  }

  @override
  void dispose() {
    processStatusNotifier.dispose();
    super.dispose();
  }
}
