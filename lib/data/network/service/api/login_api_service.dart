import 'package:chopper/chopper.dart';
import 'package:injector/injector.dart';

part 'login_api_service.chopper.dart';

/*
@Post(headers: {
  'User-Agent': 'zorro/1.0',
  'Z-Dev-Apikey': '+zorro+',
  'Content-Type': 'application/json'
})
*/
@ChopperApi(baseUrl: '/auth')
abstract class LoginApiService extends ChopperService {
  @Post(path: '/login')
  Future<Response> postLogin(@Body() String body);

  /*
    static LoginApiService create() {
    final client = ChopperClient(
        baseUrl: 'https://web.spaggiari.eu/rest/v1',
        services: [
          _$LoginApiService(),
        ],
        converter: JsonConverter());

    return _$LoginApiService(client);
  }
  */
  static LoginApiService create() {
    return _$LoginApiService(Injector.appInstance.getDependency());
  }
}
