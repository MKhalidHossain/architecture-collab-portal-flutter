import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/auth/implement/auth_interface_impl.dart';
import 'package:dana_bozzetto/moduls/auth/interface/auth_interface.dart';
import 'package:dana_bozzetto/moduls/home/interface/home_interface.dart';
import 'package:dana_bozzetto/moduls/home/service/home_interface_impl.dart';
import 'package:dana_bozzetto/moduls/profile/interface/profile_interface.dart';
import 'package:dana_bozzetto/moduls/profile/service/profile_service_interface_impl.dart';
import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/service/project_interface_impl.dart';
import 'package:dana_bozzetto/moduls/notification/interface/notification_interface.dart';
import 'package:dana_bozzetto/moduls/notification/service/notification_interface_impl.dart';
import 'package:dana_bozzetto/moduls/message/interface/message_interface.dart';
import 'package:dana_bozzetto/moduls/message/service/message_interface_impl.dart';
import 'package:dana_bozzetto/moduls/search/interface/search_interface.dart';
import 'package:dana_bozzetto/moduls/search/service/search_interface_impl.dart';
import 'package:dana_bozzetto/moduls/setting/interface/settings_interface.dart';
import 'package:dana_bozzetto/moduls/setting/service/settings_interface_impl.dart';
import 'package:get/get.dart';

void initServices() {
  // Initialize other interfaces here
  if (!Get.isRegistered<AuthInterface>()) {
    Get.put<AuthInterface>(
      AuthInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }

  if (!Get.isRegistered<ProfileInterface>()) {
    Get.put<ProfileInterface>(
      ProfileInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }

  if (!Get.isRegistered<HomeInterface>()) {
    Get.put<HomeInterface>(
      HomeInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }

  if (!Get.isRegistered<ProjectInterface>()) {
    Get.put<ProjectInterface>(
      ProjectInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }

  if (!Get.isRegistered<NotificationInterface>()) {
    Get.put<NotificationInterface>(
      NotificationInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }

  if (!Get.isRegistered<MessageInterface>()) {
    Get.put<MessageInterface>(
      MessageInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }

  if (!Get.isRegistered<SearchInterface>()) {
    Get.put<SearchInterface>(
      SearchInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }

  if (!Get.isRegistered<SettingsInterface>()) {
    Get.put<SettingsInterface>(
      SettingsInterfaceImpl(appPigeon: Get.find<AppPigeon>()),
    );
  }
  
}
