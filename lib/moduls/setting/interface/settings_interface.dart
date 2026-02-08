import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/setting/model/settings_models.dart';
import 'package:dartz/dartz.dart';

abstract base class SettingsInterface extends BaseRepository {
  Future<Either<DataCRUDFailure, Success<SettingsData>>> fetchSettings();

  Future<Either<DataCRUDFailure, Success<SettingsUpdateResponseModel>>>
      updateSettings({
    required SettingsUpdateRequestModel param,
  });
}
