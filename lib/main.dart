import 'package:flutter/material.dart';

import 'package:dana_bozzetto/core/di/external_service_di.dart';
import 'package:dana_bozzetto/core/di/internal_service_di.dart';
import 'package:get/get.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
import 'package:dana_bozzetto/moduls/auth/presentation/screen/login_screen.dart';
import 'package:dana_bozzetto/moduls/home/common/menu/client_home_screen.dart';
import 'package:dana_bozzetto/moduls/home/presentation/screens/team_member_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  externalServiceDI();
  initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthStatus>(
      future: Get.find<AppPigeon>().currentAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white70),
            ),
          );
        }
        final status = snapshot.data;
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
      },
    );
  }
}
