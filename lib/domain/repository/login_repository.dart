import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginRepository {
  /// Signs in a user having a username and a password
  /// /auth/login endpoint
  Future<Response> signIn(
      {@required String username, @required String password});

  Future<bool> isLoggedIn();
}
