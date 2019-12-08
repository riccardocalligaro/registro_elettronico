import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/domain/entity/login_response.dart';
import 'package:registro_elettronico/domain/entity/profile.dart';

abstract class LoginRepository {
  /// Signs in a user having a username and a password
  Future<LoginResponse> signIn(
      {@required String username, @required String password});
}
