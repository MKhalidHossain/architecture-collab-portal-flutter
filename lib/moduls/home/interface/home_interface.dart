import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/home/model/home_response_model.dart';
import 'package:dana_bozzetto/moduls/home/model/team_member_home_response_model.dart';
import 'package:dartz/dartz.dart';

abstract base class HomeInterface extends BaseRepository {
  Future<Either<DataCRUDFailure, Success<HomeDashboardResponse>>>
      fetchDashboard();

  Future<Either<DataCRUDFailure, Success<TeamMemberDashboardResponse>>>
      fetchTeamDashboard();
}
