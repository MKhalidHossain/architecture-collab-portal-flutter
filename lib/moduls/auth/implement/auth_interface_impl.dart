import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../interface/auth_interface.dart';
import '../model/forget_password_request_model.dart';
import '../model/login_request_model.dart';
import '../model/logout_request_model.dart';
import '../model/register_request_model.dart';
import '../model/reset_password_request_model.dart';
import '../model/verify_email_request_model.dart';
import '../model/verify_email_register_request_model.dart';
import '../../profile/model/update_profile_request_model.dart';

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
    Map<String, dynamic> readMap(dynamic data) {
      return data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    }

    DataCRUDFailure? buildForbiddenFailure(Response<dynamic>? response) {
      if (response == null) {
        return null;
      }
      final responseMap = readMap(response.data);
      final requiresVerification = responseMap['requiresVerification'] == true;
      if (response.statusCode != 403 || !requiresVerification) {
        return null;
      }
      final message = responseMap['message']?.toString() ??
          'Email not verified. Please verify your email.';
      final email = responseMap['email']?.toString() ?? '';
      final data = <String, dynamic>{};
      if (email.isNotEmpty) {
        data['email'] = email;
      }
      return DataCRUDFailure(
        failure: Failure.forbidden,
        fullError: message,
        uiMessage: message,
        data: data.isEmpty ? null : data,
      );
    }

    try {
      final response = await appPigeon.post(
        ApiEndpoints.login,
        data: param.toJson(),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        final forbiddenFailure = buildForbiddenFailure(response);
        if (forbiddenFailure != null) {
          return Left(forbiddenFailure);
        }
        final errorMessage = response.data is Map
            ? response.data['message']?.toString() ?? 'Login failed'
            : 'Login failed';
        return Left(
          DataCRUDFailure(
            failure: Failure.dioFailure,
            fullError: errorMessage,
            uiMessage: errorMessage,
          ),
        );
      }

      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      final responseData = responseBody["data"];
      final payload = responseData is Map
          ? Map<String, dynamic>.from(responseData)
          : responseBody;
      final userData = payload['user'] is Map
          ? Map<String, dynamic>.from(payload['user'])
          : payload;

      String readString(dynamic value) => value?.toString() ?? '';
      String pickFirstString(List<dynamic> values) {
        for (final value in values) {
          final stringValue = readString(value);
          if (stringValue.isNotEmpty) {
            return stringValue;
          }
        }
        return '';
      }

      final accessToken = pickFirstString([
        payload['access_token'],
        payload['accessToken'],
        payload['token'],
        responseBody['access_token'],
        responseBody['accessToken'],
        responseBody['token'],
      ]);
      var refreshToken = pickFirstString([
        payload['refresh_token'],
        payload['refreshToken'],
        responseBody['refresh_token'],
        responseBody['refreshToken'],
      ]);
      if (refreshToken.isEmpty) {
        refreshToken = accessToken;
      }
      final role = pickFirstString([
        userData['role'],
        payload['role'],
        responseBody['role'],
      ]);

      if (accessToken.isEmpty) {
        return Left(
          DataCRUDFailure(
            failure: Failure.dioFailure,
            fullError: 'Invalid token data',
            uiMessage: 'Authentication failed. Please try again.',
          ),
        );
      }

      final userId = pickFirstString([
        userData['id'],
        userData['_id'],
        payload['userId'],
        payload['_id'],
        responseBody['userId'],
        responseBody['_id'],
      ]);

      final authData = Map<String, dynamic>.from(userData);
      if (role.isNotEmpty) {
        authData['role'] = role;
      }

      // Save tokens directly using AppPigeon service
      await appPigeon.saveNewAuth(
        saveAuthParams: SaveNewAuthParams(
          accessToken: accessToken,
          refreshToken: refreshToken,
          data: authData,
          uid: userId.isNotEmpty ? userId : null,
        ),
      );

      return Right(Success(data: role));
    } on DioException catch (e) {
      final forbiddenFailure = buildForbiddenFailure(e.response);
      if (forbiddenFailure != null) {
        return Left(forbiddenFailure);
      }
      final responseData = e.response?.data;
      final errorMessage = responseData is Map
          ? responseData['message']?.toString() ?? 'Login failed'
          : responseData is String
              ? responseData
              : e.toString();
      return Left(
        DataCRUDFailure(
          failure: Failure.dioFailure,
          fullError: errorMessage,
          uiMessage: 'An error occurred. Please try again.',
        ),
      );
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

  @override
  Future<Either<DataCRUDFailure, Success<String>>> updateProfile({
    required UpdateProfileRequestModel param,
  }) async {
    return asyncTryCatch(
      tryFunc: () async {
        final formData = await param.toFormData();
        final authStatus = await appPigeon.currentAuth();
        String? accessToken;
        if (authStatus is Authenticated) {
          accessToken = authStatus.auth.accessToken;
        }
        final headers = <String, dynamic>{};
        if (accessToken != null && accessToken.isNotEmpty) {
          headers['Authorization'] = 'Bearer $accessToken';
          headers['x-auth-token'] = accessToken;
        }
        await appPigeon.put(
          ApiEndpoints.updateProfile,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
            headers: headers.isNotEmpty ? headers : null,
          ),
        );
        return Success(
          message: 'Profile Updated Successfully',
          data: "Profile Updated",
        );
      },
    );
  }
}
