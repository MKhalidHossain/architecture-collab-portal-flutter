import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/project/model/client_approval_details_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_approvals_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/project_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/team_member_get_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/project_details_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/project_finance_item.dart';
import 'package:dana_bozzetto/moduls/project/model/projects_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/create_task_request_model.dart';
import 'package:dana_bozzetto/moduls/project/model/project_task_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/task_submit_request_model.dart';
import 'package:dana_bozzetto/moduls/project/model/task_submit_response_model.dart';
import 'package:dana_bozzetto/moduls/project/model/team_portal_approvals_response_model.dart';
import 'package:dartz/dartz.dart';

abstract base class ProjectInterface extends BaseRepository {
  Future<Either<DataCRUDFailure, Success<ProjectsResponse>>> fetchProjects();

  Future<Either<DataCRUDFailure, Success<ProjectDetailsResponse>>>
      fetchProjectDetails({required String projectId});


  Future<Either<DataCRUDFailure, Success<List<ClientGetDocumentsResponseModel>>>>
      fetchClientDocuments();

  Future<Either<DataCRUDFailure, Success<List<ClientGetApprovalsResponseModel>>>>
      fetchClientApprovals();

  Future<Either<DataCRUDFailure, Success<TeamPortalApprovalsResponse>>>
      fetchTeamApprovals();

  Future<Either<DataCRUDFailure, Success<ClientApprovalDetailsResponseModel>>>
      updateClientApproval({
    required String approvalId,
    required String status,
  });

  Future<
          Either<DataCRUDFailure,
              Success<List<ProjectDocumentsResponseModel>>>>
      fetchProjectDocuments({required String projectId});

  Future<
          Either<DataCRUDFailure,
              Success<List<TeamMemberGetDocumentsResponseModel>>>>
      fetchTeamMemberDocuments();

  Future<Either<DataCRUDFailure, Success<List<ProjectFinanceItem>>>>
      fetchFinances();
  Future<Either<DataCRUDFailure, Success<ProjectTaskResponseModel>>>
      createTask({required CreateTaskRequestModel param});

  Future<Either<DataCRUDFailure, Success<List<ProjectTaskResponseModel>>>>
      fetchProjectTasks({required String projectId});

  Future<Either<DataCRUDFailure, Success<TaskSubmitResponseModel>>>
      submitTask({
    required String taskId,
    required TaskSubmitRequestModel param,
  });
}
