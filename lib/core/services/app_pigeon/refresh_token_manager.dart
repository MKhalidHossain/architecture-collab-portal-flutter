
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../debug/debug_service.dart';

base class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic>? data;
  RefreshTokenResponse({
    this.data,
    required this.accessToken,
    required this.refreshToken,
  });

}

abstract interface class RefreshTokenManagerInterface {
  final String url;

  RefreshTokenManagerInterface(this.url);
  /// Makes a http call to the relative api to get refresh token. Returns [RefreshTokenResponse]
  /// This gets called by [AuthService] on expire of access-token.
  Future<RefreshTokenResponse> refreshToken({required String refreshToken});

  Future<bool> isExpiredTokenError({required DioException err});
}

class RefreshTokenManager implements RefreshTokenManagerInterface{
  final Dio _dio = Dio();
  final String refreshTokenUrl;
  RefreshTokenManager( this.refreshTokenUrl,);

  @override
  String get url => refreshTokenUrl;

  @override
  Future<RefreshTokenResponse> refreshToken({required String refreshToken}) async{
    AuthDebugger().dekhao("Refreshing token with url: $url, refreshToken: $refreshToken");
    final response = await _dio.post(url, data: {
      "refreshToken": refreshToken,
    });
    debugPrint("Refresh token response: ${response.data}");
    final raw = response.data;
    final payload = raw is Map && raw["data"] is Map
        ? Map<String, dynamic>.from(raw["data"])
        : raw is Map
            ? Map<String, dynamic>.from(raw)
            : <String, dynamic>{};

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
      payload["accessToken"],
      payload["access_token"],
      payload["token"],
      raw is Map ? raw["accessToken"] : null,
      raw is Map ? raw["access_token"] : null,
      raw is Map ? raw["token"] : null,
    ]);
    var nextRefreshToken = pickFirstString([
      payload["refreshToken"],
      payload["refresh_token"],
      raw is Map ? raw["refreshToken"] : null,
      raw is Map ? raw["refresh_token"] : null,
    ]);
    if (nextRefreshToken.isEmpty) {
      nextRefreshToken = accessToken;
    }
    if (accessToken.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Invalid refresh token response",
      );
    }
    return RefreshTokenResponse(
      accessToken: accessToken,
      refreshToken: nextRefreshToken,
      data: (payload["userId"] != null)
        {
          "userId": payload["userId"],
        } : null
    );
  }
  
  @override
  Future<bool> isExpiredTokenError({required DioException err}) async{
    AuthDebugger().dekhao("isExpiredTokenError: ${err.response?.statusCode} error: ${err.message} ${"\n"} isRefresh: ${err.response?.statusCode == 401 && !_isRefreshRequest(err.requestOptions)}");
    bool isExpired = err.response?.statusCode == 401 && err.response?.data["message"] == "Invalid or expired token" && !_isRefreshRequest(err.requestOptions);
    debugPrint("isExpired: $isExpired");
    return isExpired;
  }

   bool _isRefreshRequest(RequestOptions request) {
    return request.path.contains(url);
  }
}
