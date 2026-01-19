import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_approvals_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/team_member_get_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/project_details_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:dartz/dartz.dart';

final class ProjectInterfaceImpl extends ProjectInterface {
  final AppPigeon appPigeon;

  ProjectInterfaceImpl({required this.appPigeon});

  @override
  Future<Either<DataCRUDFailure, Success<ProjectsResponse>>>
      fetchProjects() async {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getProjects);
        return Success(data: ProjectsResponse.fromJson(response.data));
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<ProjectDetailsResponse>>>
      fetchProjectDetails({required String projectId}) async {
    return asyncTryCatch(
      tryFunc: () async {
        final response =
            await appPigeon.get(ApiEndpoints.getProjectById(projectId));
        return Success(data: ProjectDetailsResponse.fromJson(response.data));
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<List<ClientGetDocumentsResponseModel>>>>
      fetchClientDocuments() {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getClientDocuments);
        return Success(
          data: ClientGetDocumentsResponseModel.fromJsonList(response.data),
        );
      },
    );
  }

  @override
  Future<
          Either<DataCRUDFailure,
              Success<List<ClientGetApprovalsResponseModel>>>>
      fetchClientApprovals() {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getClientApprovals);
        return Success(
          data: ClientGetApprovalsResponseModel.fromJsonList(response.data),
        );
      },
    );
  }

  @override
  Future<
          Either<DataCRUDFailure,
              Success<List<TeamMemberGetDocumentsResponseModel>>>>
      fetchTeamMemberDocuments() {
    return asyncTryCatch(
      tryFunc: () async {
        final response =
            await appPigeon.get(ApiEndpoints.getTeamMemberDocuments);
        return Success(
          data: TeamMemberGetDocumentsResponseModel.fromJsonList(response.data),
        );
      },
    );
  }
}
