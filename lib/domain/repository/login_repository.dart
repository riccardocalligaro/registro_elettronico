import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/domain/entity/api_responses/login_response.dart';

abstract class LoginRepository {
  /// Signs in a user having a username and a password
  Future<LoginResponse> signIn(
      {@required String username, @required String password});
}
