import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/parent_response_remote_model.dart';

class GenericLoginResponse {
  Either<ParentLoginResponseRemoteModel, DefaultLoginResponseRemoteModel>
      response;

  GenericLoginResponse({required this.response});
}
