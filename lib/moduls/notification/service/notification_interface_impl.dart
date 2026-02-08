import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/notification/interface/notification_interface.dart';
import 'package:dana_bozzetto/moduls/notification/model/notification_response_model.dart';
import 'package:dartz/dartz.dart';

final class NotificationInterfaceImpl extends NotificationInterface {
  final AppPigeon appPigeon;

  NotificationInterfaceImpl({required this.appPigeon});

  @override
  Future<Either<DataCRUDFailure, Success<NotificationResponse>>>
      fetchNotifications() async {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getAllNotifications);
        final data = response.data;
        var payload = <String, dynamic>{};
        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          payload = map['data'] is Map
              ? Map<String, dynamic>.from(map['data'])
              : map;
        }
        return Success(data: NotificationResponse.fromJson(payload));
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<void>>> markNotificationRead({
    required String notificationId,
  }) async {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.put(
          ApiEndpoints.markNotificationAsRead(notificationId: notificationId),
        );
        return Success<void>(data: null);
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<void>>> markAllRead() async {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.put(ApiEndpoints.markAllRead);
        return Success<void>(data: null);
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<void>>> deleteNotification({
    required String notificationId,
  }) async {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.delete(
          ApiEndpoints.deleteNotification(notificationId),
        );
        return Success<void>(data: null);
      },
    );
  }
}
