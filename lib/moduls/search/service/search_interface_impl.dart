import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/search/interface/search_interface.dart';
import 'package:dana_bozzetto/moduls/search/model/search_response_model.dart';
import 'package:dartz/dartz.dart';

final class SearchInterfaceImpl extends SearchInterface {
  final AppPigeon appPigeon;

  SearchInterfaceImpl({required this.appPigeon});

  @override
  Future<Either<DataCRUDFailure, Success<SearchResponse>>> searchClient({
    required String query,
  }) async {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(
          ApiEndpoints.clientPortalSearch,
          query: _buildQuery(query),
        );
        return Success(data: _parseSearchResponse(response.data));
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<SearchResponse>>> searchTeam({
    required String query,
  }) async {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(
          ApiEndpoints.teamPortalSearch,
          query: _buildQuery(query),
        );
        return Success(data: _parseSearchResponse(response.data));
      },
    );
  }

  Map<String, dynamic>? _buildQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return null;
    return {'q': trimmed};
  }

  SearchResponse _parseSearchResponse(dynamic data) {
    var payload = <String, dynamic>{};
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      payload = map['data'] is Map
          ? Map<String, dynamic>.from(map['data'])
          : map;
    }
    return SearchResponse.fromJson(payload);
  }
}
