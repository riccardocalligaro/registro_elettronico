import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginRepository {
  Future<Response> signIn(
      {@required String username, @required String password});
}
