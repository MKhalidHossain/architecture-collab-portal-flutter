import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/setting/interface/settings_interface.dart';
import 'package:dana_bozzetto/moduls/setting/model/settings_models.dart';
import 'package:dartz/dartz.dart';

final class SettingsInterfaceImpl extends SettingsInterface {
  final AppPigeon appPigeon;

  SettingsInterfaceImpl({required this.appPigeon});

  @override
  Future<Either<DataCRUDFailure, Success<SettingsData>>> fetchSettings() {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.settings);
        final data = response.data;
        var payload = <String, dynamic>{};
        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          payload = map['data'] is Map
              ? Map<String, dynamic>.from(map['data'])
              : map;
        }
        return Success(data: SettingsData.fromJson(payload));
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<SettingsUpdateResponseModel>>>
      updateSettings({required SettingsUpdateRequestModel param}) {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.put(
          ApiEndpoints.settings,
          data: param.toJson(),
        );
        final data = response.data;
        final payload = data is Map<String, dynamic>
            ? Map<String, dynamic>.from(data)
            : <String, dynamic>{};
        return Success(data: SettingsUpdateResponseModel.fromJson(payload));
      },
    );
  }
}
