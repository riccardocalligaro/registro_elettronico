import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/feature/login/data/model/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/data/model/parent_response_remote_model.dart';

abstract class LoginRepository {
  /// Signs in a user having a username and a password
  Future<Either<LoginResponse, ParentsLoginResponse>> signIn(
      {@required String username, @required String password});
}
