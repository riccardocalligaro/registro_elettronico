import 'package:chopper/chopper.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/domain/entity/profile.dart';


part 'login_api_service.chopper.dart';

@ChopperApi(baseUrl: '/auth')
abstract class LoginApiService extends ChopperService {
  @Post(path: '/login')
  Future<Response<Profile>> postLogin(@Body() String body);

  static LoginApiService create() {
    return _$LoginApiService(Injector.appInstance.getDependency());
  }
}
