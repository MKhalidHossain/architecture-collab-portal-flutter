import 'package:dana_bozzetto/moduls/notification/interface/notification_interface.dart';
import 'package:dana_bozzetto/moduls/notification/model/notification_response_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationInterface _notificationInterface =
      Get.find<NotificationInterface>();

  final RxList<NotificationItemModel> notifications =
      <NotificationItemModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _notificationInterface.fetchNotifications();
    result.fold(
      (failure) {
        errorMessage.value = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        final data = success.data ?? NotificationResponse.empty();
        notifications.assignAll(data.notifications);
        unreadCount.value = data.unreadCount;
      },
    );

    isLoading.value = false;
  }

  Future<void> markNotificationRead(String notificationId) async {
    final index =
        notifications.indexWhere((element) => element.id == notificationId);
    if (index == -1) return;

    final result = await _notificationInterface.markNotificationRead(
      notificationId: notificationId,
    );
    result.fold(
      (failure) {
        errorMessage.value = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        final item = notifications[index];
        if (!item.isRead) {
          notifications[index] = item.copyWith(isRead: true);
          unreadCount.value = unreadCount.value > 0
              ? unreadCount.value - 1
              : unreadCount.value;
        }
      },
    );
  }

  Future<void> markAllRead() async {
    final result = await _notificationInterface.markAllRead();
    result.fold(
      (failure) {
        errorMessage.value = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        notifications.assignAll(
          notifications.map((item) => item.copyWith(isRead: true)).toList(),
        );
        unreadCount.value = 0;
      },
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    final index =
        notifications.indexWhere((element) => element.id == notificationId);
    if (index == -1) return;

    final wasUnread = !notifications[index].isRead;
    final result = await _notificationInterface.deleteNotification(
      notificationId: notificationId,
    );
    result.fold(
      (failure) {
        errorMessage.value = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        notifications.removeAt(index);
        if (wasUnread && unreadCount.value > 0) {
          unreadCount.value = unreadCount.value - 1;
        }
      },
    );
  }
}
