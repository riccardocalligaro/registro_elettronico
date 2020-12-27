import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/feature/login/data/model/login_request_model.dart';
import 'package:registro_elettronico/feature/login/data/model/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/data/model/parent_response_remote_model.dart';
import 'package:registro_elettronico/feature/login/domain/repository/login_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ProfileDao profileDao;
  final SpaggiariClient spaggiariClient;
  final NetworkInfo networkInfo;

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
