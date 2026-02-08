import 'dart:async';

import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
import 'package:dana_bozzetto/moduls/auth/presentation/screen/login_screen.dart';

import 'package:dana_bozzetto/moduls/home/presentation/screens/team_member_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../moduls/home/common/menu/client_home_screen.dart';

class AppManager extends ChangeNotifier {
  final AppPigeon _appPigeon;
  late final StreamSubscription<AuthStatus> _subscription;

  AuthStatus _currentAuthStatus = UnAuthenticated();
  AuthStatus get currentAuthStatus => _currentAuthStatus;

  AppManager({AppPigeon? appPigeon})
    : _appPigeon = appPigeon ?? Get.find<AppPigeon>() {
    _subscription = _appPigeon.authStream.listen(_handleAuthStatus);
    _loadCurrentAuth();
  }

  Future<void> _loadCurrentAuth() async {
    _currentAuthStatus = await _appPigeon.currentAuth();
    notifyListeners();
  }

  void _handleAuthStatus(AuthStatus status) {
    _currentAuthStatus = status;
    notifyListeners();
  }

  Widget get startScreen {
    final status = _currentAuthStatus;
    if (status is Authenticated) {
      switch (status.auth.authRole) {
        case AuthRole.client:
          return ClientHomeScreen(userId: status.auth.userId);
        case AuthRole.teamMember:
          return TeamMemberHomeScreen(userId: status.auth.userId);
        case AuthRole.unknown:
          break;
      }
    }
    return const LoginScreen();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
