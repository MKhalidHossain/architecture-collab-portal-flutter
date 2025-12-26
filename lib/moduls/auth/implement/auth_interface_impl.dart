import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dartz/dartz.dart';
import '../interface/auth_interface.dart';
import '../model/forget_password_request_model.dart';
import '../model/login_request_model.dart';
import '../model/logout_request_model.dart';
import '../model/register_request_model.dart';
import '../model/reset_password_request_model.dart';
import '../model/verify_email_request_model.dart';
import '../model/verify_email_register_request_model.dart';

final class AuthInterfaceImpl extends AuthInterface {
  final AppPigeon appPigeon;

  AuthInterfaceImpl({required this.appPigeon});

  ///{signup}
  @override
  Future<Either<DataCRUDFailure, Success<String>>> register({
    required RegisterRequest param,
  }) async {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.signup,
          data: param.toJson(),
        );
        return Success(
          message: 'Register Successfuly',
          data: "Successful Login.",
        );
      },
    );
  }

  ///{logout}
  @override
  Future<Either<DataCRUDFailure, Success<String>>> logout({
    required LogoutRequestModel param,
  }) async {
    return await asyncTryCatch(
      tryFunc: () async {
        try {
          await appPigeon.post(ApiEndpoints.logout, data: param.toJson());
        } finally {
          await appPigeon.logOut();
        }
        return Success(message: 'Logout Succesfuly', data: "Logged out");
      },
    );
  }

  // @override
  // Stream<AuthStatus> authStream() {
  //   return appPigeon.authStream;
  // }

  @override
  Future<Either<DataCRUDFailure, Success<String>>> login({
    required LoginRequestModel param,
  }) async {
    try {
      final response = await appPigeon.post(
        ApiEndpoints.login,
        data: param.toJson(),
      );

      if (response.statusCode != 200) {
        final errorMessage =
            response.data['message']?.toString() ?? 'Login failed';
        return Left(
          DataCRUDFailure(
            failure: Failure.dioFailure,
            fullError: errorMessage,
            uiMessage: errorMessage,
          ),
        );
      }

      final responseData = response.data["data"] ?? {};
      final userData = (responseData is Map)
          ? Map<String, dynamic>.from(responseData)
          : <String, dynamic>{};

      final accessToken = userData['accessToken']?.toString() ?? '';
      final refreshToken = userData['refreshToken']?.toString() ?? '';
      final role = userData['role']?.toString() ?? '';

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        return Left(
          DataCRUDFailure(
            failure: Failure.dioFailure,
            fullError: 'Invalid token data',
            uiMessage: 'Authentication failed. Please try again.',
          ),
        );
      }

      // Save tokens directly using AppPigeon service
      await appPigeon.saveNewAuth(
        saveAuthParams: SaveNewAuthParams(
          accessToken: accessToken,
          refreshToken: refreshToken,
          data: userData,
          uid: responseData['user']['id'],
        ),
      );

      return Right(Success(data: role));
    } catch (e) {
      return Left(
        DataCRUDFailure(
          failure: Failure.dioFailure,
          fullError: e.toString(),
          uiMessage: 'An error occurred. Please try again.',
        ),
      );
    }
  }

  ///{Forget Password}
  @override
  Future<Either<DataCRUDFailure, Success<String>>> forgetPassword({
    required ForgetPasswordRequestModel param,
  }) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.forgetPassword,
          data: param.toJson(),
        );
        return Success(message: 'OTP send to your mail', data: '');
      },
    );
  }

  ///{Verify Email}
  @override
  Future<Either<DataCRUDFailure, Success<String>>> verifyEmail({
    required VerifyEmailRequestModel param,
  }) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.verifyCode,
          data: param.toJson(),
        );
        final data = response.data['data'];
        String userId = '';
        if (data is Map) {
          if (data['userId'] != null) {
            userId = data['userId'].toString();
          } else if (data['user'] is Map && data['user']['id'] != null) {
            userId = data['user']['id'].toString();
          } else if (data['user'] is Map && data['user']['_id'] != null) {
            userId = data['user']['_id'].toString();
          }
        }
        return Success(message: 'Email verified successfully', data: userId);
      },
    );
  }

  ///{Verify Register Email}
  @override
  Future<Either<DataCRUDFailure, Success<String>>> verifyRegisterEmail({
    required VerifyEmailRegisterRequestModel param,
  }) async {
    return await asyncTryCatch(
      tryFunc: () async {
        await appPigeon.post(ApiEndpoints.verifyEmail, data: param.toJson());
        return Success(message: 'Email verified successfully', data: '');
      },
    );
  }

  ///{Reset Password}
  @override
  Future<Either<DataCRUDFailure, Success<String>>> resetPassword({
    required ResetPasswordRequestModel param,
  }) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.put(
          ApiEndpoints.resetPassword,
          data: param.toJson(),
        );
        return Success(message: 'Password reset successfully', data: '');
      },
    );
  }
}
