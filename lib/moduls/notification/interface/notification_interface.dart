import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/notification/model/notification_response_model.dart';
import 'package:dartz/dartz.dart';

abstract base class NotificationInterface extends BaseRepository {
  Future<Either<DataCRUDFailure, Success<NotificationResponse>>>
      fetchNotifications();

  Future<Either<DataCRUDFailure, Success<void>>> markNotificationRead({
    required String notificationId,
  });

  Future<Either<DataCRUDFailure, Success<void>>> markAllRead();

  Future<Either<DataCRUDFailure, Success<void>>> deleteNotification({
    required String notificationId,
  });
}
