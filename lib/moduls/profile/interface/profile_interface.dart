import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/profile/model/update_profile_request_model.dart';
import 'package:dartz/dartz.dart';

abstract base class ProfileInterface  extends BaseRepository {
  Future<Either<DataCRUDFailure,Success<String>>> uploadProfileImage({required UpdateProfileRequestModel param});  
  
}