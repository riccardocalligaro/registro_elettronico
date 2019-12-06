import 'package:chopper/chopper.dart';
import 'package:registro_elettronico/component/api_config.dart';

class SpaggiariClient {
  static ChopperClient _chopperClient;
  // static Map _headers = Map<String, String>();
  static Map<String, String> _headers = {
    "User-Agent":"zorro/1.0",
    "Z-Dev-Apikey":"+zorro+",
    "content-type":"application/json"
  };

  // SpaggiariClient._();

  static ChopperClient i() {
    if (_chopperClient == null) {
      _chopperClient = ChopperClient(
          baseUrl: '${ApiConfig.BASE_API_URL}',
          errorConverter: JsonConverter(),
          interceptors: [
            HeadersInterceptor(_headers)
            // TODO: interceptors for token
          ]);

          // TODO: implement json convert factory
    }
    return _chopperClient;
  }
}
