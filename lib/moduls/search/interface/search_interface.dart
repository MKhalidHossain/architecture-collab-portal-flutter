import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/search/model/search_response_model.dart';
import 'package:dartz/dartz.dart';

abstract base class SearchInterface extends BaseRepository {
  Future<Either<DataCRUDFailure, Success<SearchResponse>>> searchClient({
    required String query,
  });

  Future<Either<DataCRUDFailure, Success<SearchResponse>>> searchTeam({
    required String query,
  });
}
