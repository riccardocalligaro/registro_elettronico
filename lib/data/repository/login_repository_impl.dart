import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/network/service/api/login_api_service.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginApiService loginApiService;
  ProfileDao profileDao;

  LoginRepositoryImpl(this.loginApiService, this.profileDao);

  @override
  Future<Response> signIn({String username, String password}) async {
    try {
      final loginData = {
        "ident": "$username",
        "pass": "$password",
        "uid": "$username"
      };
      final body = json.encode(loginData);
      final res = await loginApiService.postLogin(body);

      return res;
    } catch (ex) {
      print(
          "Login repository implementation, sign in method, ${ex.toString()}");
    }
  }

  Future<bool> isLoggedIn() async{
    final profiles = await profileDao.getAllProfiles();
    return (profiles.length>=1);
  }
}
