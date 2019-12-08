import 'dart:convert';

import 'package:alice/alice.dart';
import 'package:chopper/chopper.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/login_request.dart';
import 'package:registro_elettronico/domain/entity/login_response.dart';
import 'package:registro_elettronico/domain/entity/profile.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  ProfileDao profileDao;
  ProfileMapper profileMapper;
  SpaggiariClient spaggiariClient;

  LoginRepositoryImpl(
      this.profileDao, this.profileMapper, this.spaggiariClient);

  @override
  Future<LoginResponse> signIn({String username, String password}) async {
    try {
      final loginRequest =
          LoginRequest(ident: username, pass: password, uid: username);
      try {
        final res = await spaggiariClient.loginUser(loginRequest);
        return res;
      } catch (e) {
        print(e);
      }
    } catch (ex) {
      print(
          "Login repository implementation, sign in method, ${ex.toString()}");
    }
  }

  // TODO: divide profile and login

  Future<bool> isLoggedIn() async {
    final profiles = await profileDao.getAllProfiles();
    return (profiles.length >= 1);
  }

  @override
  Future deleteProfile({Profile profile}) => profileDao.deleteProfile(
      profileMapper.mapProfileEntityToProfileInsertable(profile));

  @override
  Future insertProfile({Profile profile}) => profileDao.insertProfile(
      profileMapper.mapProfileEntityToProfileInsertable(profile));

  @override
  Future deleteAllProfiles() => profileDao.deleteAllProfiles();
}
