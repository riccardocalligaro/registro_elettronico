import 'package:chopper/chopper.dart';

part 'login_api_service.chopper.dart';

@ChopperApi(baseUrl: '/auth')
@Post(headers: {
  'User-Agent': 'zorro/1.0',
  'Z-Dev-Apikey': '+zorro+',
  'Content-Type': 'application/json'
})
abstract class LoginApiService extends ChopperService {
  @Post(path: '/login', headers: {
    'User-Agent': 'zorro/1.0',
    'Z-Dev-Apikey': '+zorro+',
    'Content-Type': 'application/json'
  })
  Future<Response> postLogin(@Body() Map<String, dynamic> body);

  static LoginApiService create() {
    final client = ChopperClient(
        baseUrl: 'https://web.spaggiari.eu/rest/v1',
        services: [
          _$LoginApiService(),
        ],
        converter: JsonConverter());

    return _$LoginApiService(client);
  }
}
