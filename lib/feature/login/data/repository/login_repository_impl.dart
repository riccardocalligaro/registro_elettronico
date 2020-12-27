import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/core/network/network_info.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/feature/login/data/model/login_request_model.dart';
import 'package:registro_elettronico/feature/login/data/model/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/data/model/parent_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  ProfileDao profileDao;
  SpaggiariClient spaggiariClient;
  NetworkInfo networkInfo;

  LoginRepositoryImpl(
    this.profileDao,
    this.spaggiariClient,
    this.networkInfo,
  );

  @override
  Future<Either<LoginResponse, ParentsLoginResponse>> signIn({
    String username,
    String password,
  }) async {
    if (await networkInfo.isConnected) {
      final loginRequest =
          LoginRequest(ident: username, pass: password, uid: username);

      final res = await spaggiariClient.loginUser(loginRequest);
      return res;
    } else {
      throw NotConntectedException();
    }
  }
}
