import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_approvals_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/team_member_get_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/project_details_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:dartz/dartz.dart';

abstract base class ProjectInterface extends BaseRepository {
  Future<Either<DataCRUDFailure, Success<ProjectsResponse>>> fetchProjects();

  Future<Either<DataCRUDFailure, Success<ProjectDetailsResponse>>>
      fetchProjectDetails({required String projectId});


  Future<Either<DataCRUDFailure, Success<List<ClientGetDocumentsResponseModel>>>>
      fetchClientDocuments();

  Future<Either<DataCRUDFailure, Success<List<ClientGetApprovalsResponseModel>>>>
      fetchClientApprovals();

  Future<
          Either<DataCRUDFailure,
              Success<List<TeamMemberGetDocumentsResponseModel>>>>
      fetchTeamMemberDocuments();
}
