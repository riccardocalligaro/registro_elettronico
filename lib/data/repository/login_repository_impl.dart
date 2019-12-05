import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/data/network/service/api/login_api_service.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginApiService loginApiService;
  LoginRepositoryImpl(this.loginApiService);

  @override
  Future<Response> signIn({String username, String password}) async {
    try {
      final res = await loginApiService.postLogin(
          {"ident": username, "username": username, "password": password});
      if (res.isSuccessful) {
        print(res.body.toString());
      } else {
        print(res.statusCode);
      }
    } catch (ex) {
      print(
          "Login repository implementation, sign in method, ${ex.toString()}");
    }
  }
}
