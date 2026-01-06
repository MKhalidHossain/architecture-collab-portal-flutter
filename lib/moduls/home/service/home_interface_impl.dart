import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/home/interface/home_interface.dart';
import 'package:dana_bozzetto/moduls/home/model/home_response_model.dart';
import 'package:dartz/dartz.dart';

final class HomeInterfaceImpl extends HomeInterface {
  final AppPigeon appPigeon;

  HomeInterfaceImpl({required this.appPigeon});

  @override
  Future<Either<DataCRUDFailure, Success<HomeDashboardResponse>>>
      fetchDashboard() async {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(
          ApiEndpoints.clientPortalDashboard,
        );
        final data = response.data;
        var payload = <String, dynamic>{};
        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          payload = map['data'] is Map
              ? Map<String, dynamic>.from(map['data'])
              : map;
        }
        return Success(data: HomeDashboardResponse.fromJson(payload));
      },
    );
  }
}
