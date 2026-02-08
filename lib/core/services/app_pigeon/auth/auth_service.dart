
part of '../app_pigeon.dart';

class _CancelRefreshToken extends CancelToken {}

class _AuthStatusDecider {
  static AuthStatus get(Auth? auth) {
    if(auth == null) {
      return UnAuthenticated();
    } 
    return Authenticated(auth: auth);
  }
}


class AuthService extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage _secureStorage;
  final RefreshTokenManagerInterface refreshTokenManager;
  final Debugger _authDebugger = AuthDebugger();
  late final _AuthStorage _authStorage;
  Auth? _cachedAuth;
  AuthService(this._secureStorage, this.dio, this.refreshTokenManager){
    _authStorage = _AuthStorage(secureStorage: _secureStorage);
  }

  void init() {
    _authDebugger.dekhao("Initializing auth service...");
    _authStorage.init();
  }

  Stream<AuthStatus> get authStream => _authStorage._authStreamController.stream;

  Future<AuthStatus> currentAuth() async=> await _authStorage.currentAuthStatus();
  Future<void> dispose() async{
    _authStorage.dispose();
  }

  bool _refreshingToken = false;
  /// Attach access token to every request
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    final auth = _cachedAuth ?? await _authStorage.getCurrentAuth();
    if (auth != null) {
      _cachedAuth = auth;
    }
    final accessToken = auth?._accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      options.headers['x-auth-token'] = accessToken;
    }
    _authDebugger.dekhao("${options.uri.toString()} ${options.method}");    
    _authDebugger.dekhao("${options.data.toString()} ");

    handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    debugPrint("Response << Method: ${response.requestOptions.method} API: ${response.requestOptions.uri} << ${response.data}");
    handler.next(response);
  }
  
  /// Catch errors like 401 and retry with new access token if access token expires.
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint("Error >> Method: ${err.requestOptions.method} API: ${err.requestOptions.uri} >> ${err.response}");
    // IF TIMEOUT, then possibly internet is down. Hence reject the request.
    final auth = _cachedAuth ?? await _authStorage.getCurrentAuth();
    if (auth != null) {
      _cachedAuth = auth;
    }
    final refreshToken = auth?._refreshToken ?? "";
    if(err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.receiveTimeout) {
      _authDebugger.dekhao("Timeout error");
      return handler.reject(err);
    }
    if(_refreshingToken) {
      _authDebugger.dekhao("Already refreshing token");
      return handler.reject(err);
    }
    
    if(err.requestOptions.cancelToken != null) {
      return handler.reject(err);
    }

    if (err.response?.statusCode == 401 && refreshToken.isNotEmpty) {
      // get new access token
      RefreshTokenResponse refreshTokenResponse;
      try {
        _refreshingToken = true;
        refreshTokenResponse = await refreshTokenManager.refreshToken(
          refreshToken: refreshToken,
        );
        _refreshingToken = false;
        await updateCurrentAuth(
          updateAuthParams: UpdateAuthParams(
            accessToken: refreshTokenResponse.accessToken,
            refreshToken: refreshTokenResponse.refreshToken,
            data: refreshTokenResponse.data,
          ),
        );
        // Wait a second to receive changes from secure storage.
        await Future.delayed(Duration(seconds: 1)).then((_) async{
          final RequestOptions requestOptions = err.requestOptions;

          try {
            final cloneReq = await dio.request(
              requestOptions.path,
              options: Options(
                method: requestOptions.method,
                contentType: requestOptions.contentType,
              ),
              cancelToken: _CancelRefreshToken(),
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );
            return handler.resolve(cloneReq);
          } catch (e) {
            return handler.reject(e as DioException);
          }
        });
      } catch (e) {
        _refreshingToken = false;
        return handler.reject(e as DioException);
      }
    } else {
      _authDebugger.dekhao("error debug from dio interceptor: ${err.response?.data}");
      debugPrint(err.message);
      return handler.next(err);
    }
    
  }

  Future<bool> refreshCurrentAuth() async {
    if (_refreshingToken) {
      _authDebugger.dekhao("Already refreshing token");
      return false;
    }
    final auth = _cachedAuth ?? await _authStorage.getCurrentAuth();
    if (auth != null) {
      _cachedAuth = auth;
    }
    final refreshToken = auth?._refreshToken ?? "";
    if (refreshToken.isEmpty) {
      return false;
    }
    try {
      _refreshingToken = true;
      final refreshTokenResponse = await refreshTokenManager.refreshToken(
        refreshToken: refreshToken,
      );
      await updateCurrentAuth(
        updateAuthParams: UpdateAuthParams(
          accessToken: refreshTokenResponse.accessToken,
          refreshToken: refreshTokenResponse.refreshToken,
          data: refreshTokenResponse.data,
        ),
      );
      return true;
    } catch (e) {
      return false;
    } finally {
      _refreshingToken = false;
    }
  }

  /// Saves the new auth as currentAuth.
  /// Throws Exception, if user is still logged in.
  /// Must logout first.
  Future<void> saveNewAuth({required SaveNewAuthParams saveNewAuthParams}) async {
    await _authStorage.saveNewAuth(saveNewAuthParams);
    _cachedAuth = Auth._internal(
      accessToken: saveNewAuthParams.accessToken,
      refreshToken: saveNewAuthParams.refreshToken,
      data: saveNewAuthParams.data,
    );
  }

  Future<void> updateCurrentAuth({required UpdateAuthParams updateAuthParams}) async {
    await _authStorage.updateCurrentAuth(updateAuthParams);
    _cachedAuth = Auth._internal(
      accessToken: updateAuthParams.accessToken,
      refreshToken: updateAuthParams.refreshToken,
      data: updateAuthParams.data ?? _cachedAuth?.data ?? <String, dynamic>{},
    );
  }

  Future<void> clearCurrentAuthRecord() async {
    await _authStorage.clearCurrentAuthRecord();
    _cachedAuth = null;
  }

}
