import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';

import 'package:dana_bozzetto/moduls/profile/interface/profile_interface.dart';
import 'package:dana_bozzetto/moduls/profile/model/update_profile_request_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

final class ProfileInterfaceImpl extends ProfileInterface {
  final AppPigeon appPigeon;

  ProfileInterfaceImpl({required this.appPigeon});

  @override
  Future<Either<DataCRUDFailure, Success<String>>> uploadProfileImage({
    required UpdateProfileRequestModel param,
  }) async {
    return asyncTryCatch(
      tryFunc: () async {
        final formData = await param.toFormData();
        final response = await appPigeon.put(
          ApiEndpoints.updateProfile,
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        );
        return Success(
          message: 'Profile Updated Successfully',
          data: "Profile Updated",
        );
      },
    );
  }
}
