import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/login_request.dart';
import 'package:registro_elettronico/domain/entity/login_response.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  ProfileDao profileDao;
  ProfileMapper profileMapper;
  SpaggiariClient spaggiariClient;

  LoginRepositoryImpl(
      this.profileDao, this.profileMapper, this.spaggiariClient);

  @override
  Future<LoginResponse> signIn({String username, String password}) async {
    final loginRequest =
        LoginRequest(ident: username, pass: password, uid: username);

    final res = await spaggiariClient.loginUser(loginRequest);
    return res;
  }
}
