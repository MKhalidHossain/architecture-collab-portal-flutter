import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/auth/implement/auth_interface_impl.dart';
import 'package:dana_bozzetto/moduls/auth/interface/auth_interface.dart';
import 'package:get/get.dart';

void initServices() {
  // Initialize other interfaces here
  if (!Get.isRegistered<AuthInterface>()) {
    Get.put<AuthInterface>(
      AuthInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }
  
}
