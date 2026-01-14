import 'package:dana_bozzetto/moduls/home/common/menu/client_home_screen.dart';
import 'package:dana_bozzetto/moduls/onboarding/onboarding1.dart';
import 'package:flutter/material.dart';
import 'package:dana_bozzetto/core/di/external_service_di.dart';
import 'package:dana_bozzetto/core/di/internal_service_di.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      // home: Center(child: Text("Ki obostha khalid vai"),),
       home: Onboarding1(),
      // home: ClientHomeScreen(),
    );
  }
}
