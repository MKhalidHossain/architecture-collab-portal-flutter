import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
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
  Future<Either<DataCRUDFailure, Success<TeamPortalApprovalsResponse>>>
      fetchTeamApprovals() {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getTeamApprovals);
        final data = response.data;
        var payload = <String, dynamic>{};
        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          payload = map['data'] is Map
              ? Map<String, dynamic>.from(map['data'])
              : map;
        }
        return Success(data: TeamPortalApprovalsResponse.fromJson(payload));
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<ClientApprovalDetailsResponseModel>>>
      updateClientApproval({
    required String approvalId,
    required String status,
  }) {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.put(
          ApiEndpoints.updateClientApproval(approvalId),
          data: {'status': status},
        );
        final data = response.data;
        if (data is Map) {
          final mapped = Map<String, dynamic>.from(data);
          final model = ClientApprovalDetailsResponseModel.fromJson(mapped);
          return Success(
            message: model.message ?? "Success",
            data: model,
          );
        }
        return Success(message: "Success");
      },
    );
  }

  @override
  Future<
          Either<DataCRUDFailure,
              Success<List<ProjectDocumentsResponseModel>>>>
      fetchProjectDocuments({required String projectId}) {
    return asyncTryCatch(
      tryFunc: () async {
        final response =
            await appPigeon.get(ApiEndpoints.getProjectDocuments(projectId));
        return Success(
          data: ProjectDocumentsResponseModel.fromJsonList(response.data),
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

  @override
  Future<Either<DataCRUDFailure, Success<List<ProjectFinanceItem>>>>
      fetchFinances() {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.getFinances);
        final data = response.data;
        final payload =
            data is Map && data['data'] is List ? data['data'] : data;
        return Success(
          data: ProjectFinanceItem.fromJsonList(payload),
        );
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<ProjectTaskResponseModel>>> createTask({
    required CreateTaskRequestModel param,
  }) {
    return asyncTryCatch(
      tryFunc: () async {
        final response =
            await appPigeon.post(ApiEndpoints.createTask, data: param.toJson());
        final data = response.data;
        if (data is Map) {
          return Success(
            data: ProjectTaskResponseModel.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
        return Success();
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<List<ProjectTaskResponseModel>>>>
      fetchProjectTasks({required String projectId}) {
    return asyncTryCatch(
      tryFunc: () async {
        final response =
            await appPigeon.get(ApiEndpoints.getProjectTasks(projectId));
        return Success(
          data: ProjectTaskResponseModel.fromJsonList(response.data),
        );
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<TaskSubmitResponseModel>>> submitTask({
    required String taskId,
    required TaskSubmitRequestModel param,
  }) {
    return asyncTryCatch(
      tryFunc: () async {
        final formData = await param.toFormData();
        final response = await appPigeon.post(
          ApiEndpoints.submitTask(taskId),
          data: formData,
        );
        final data = response.data;
        if (data is Map) {
          return Success(
            data: TaskSubmitResponseModel.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
        return Success();
      },
    );
  }
}
