import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../interface/profile_interface.dart';
import '../model/update_profile_request_model.dart';

class ProfileController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: EnabledStatus());
  final SnackbarNotifier snackbarNotifier;

  ProfileController(this.snackbarNotifier);

  Future<bool> updateProfile({
    required UpdateProfileRequestModel param,
  }) async {
    processStatusNotifier.setLoading();
    final result = await Get.find<ProfileInterface>().uploadProfileImage(
      param: param,
    );
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
