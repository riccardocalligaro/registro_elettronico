import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class LoginRepository {
  /// Signs in a user having a username and a password
  /// /auth/login endpoint
  Future<Response<Profile>> signIn(
      {@required String username, @required String password});

  Future<bool> isLoggedIn();
}
