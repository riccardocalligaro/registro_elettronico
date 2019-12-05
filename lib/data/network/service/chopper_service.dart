import 'package:chopper/chopper.dart';
import 'package:registro_elettronico/component/api_config.dart';

class SpaggiariClient {
  static ChopperClient _chopperClient;
  static Map _headers = Map<String, String>();

  static ChopperClient i() {
    if (_chopperClient == null) {
      _chopperClient = ChopperClient(
          baseUrl: '${ApiConfig.BASE_API_URL}',
          errorConverter: JsonConverter(),
          interceptors: [
            HeadersInterceptor(_headers)
            // todo - interceptors for token
          ]);
    }
    return _chopperClient;
  }
}
