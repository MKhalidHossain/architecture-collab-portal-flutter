import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:dartz/dartz.dart';

abstract base class ProjectInterface extends BaseRepository {
  Future<Either<DataCRUDFailure, Success<ProjectsResponse>>> fetchProjects();
}
