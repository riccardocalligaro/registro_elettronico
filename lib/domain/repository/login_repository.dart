import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/domain/entity/api_responses/login_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/parent_response.dart';

abstract class LoginRepository {
  /// Signs in a user having a username and a password
  Future<Either<LoginResponse, ParentsLoginResponse>> signIn(
      {@required String username, @required String password});
}
