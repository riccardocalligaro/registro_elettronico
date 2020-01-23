import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/api_responses/parent_response.dart';
import 'package:registro_elettronico/domain/entity/entities.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  ProfileDao profileDao;
  ProfileMapper profileMapper;
  SpaggiariClient spaggiariClient;

  LoginRepositoryImpl(
      this.profileDao, this.profileMapper, this.spaggiariClient);

  @override
  Future<Either<LoginResponse, ParentsLoginResponse>> signIn({
    String username,
    String password,
  }) async {
    final loginRequest =
        LoginRequest(ident: username, pass: password, uid: username);

    final res = await spaggiariClient.loginUser(loginRequest);
    return res;
  }
}
