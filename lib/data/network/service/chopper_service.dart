import 'package:chopper/chopper.dart';
import 'package:registro_elettronico/component/api_config.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/json_serializable_converter.dart';

class SpaggiariClient {
  static ChopperClient _chopperClient;
  // static Map _headers = Map<String, String>();
  static Map<String, String> _headers = {
    "User-Agent": "zorro/1.0",
    "Z-Dev-Apikey": "+zorro+",
    "Content-Type": "application/json"
  };

  static Map<String, String> _headers2 = {
    "User-Agent": "CVVS/std/1.6.1 Android/1.6.1",
    "Z-Dev-Apikey": "Tg1NWEwNGIgIC0K",
    "content-type": "application/json"
  };

  // SpaggiariClient._();

  static ChopperClient i() {
    if (_chopperClient == null) {
      _chopperClient = ChopperClient(
          baseUrl: '${ApiConfig.BASE_API_URL}',
          errorConverter: JsonConverter(),
          converter: JsonConverter(),
          //converter: JsonToTypeConverter(
          //     {Profile: (jsonData) => Profile.fromJson(jsonData)}),
          interceptors: [
            HttpLoggingInterceptor(),
            HeadersInterceptor(_headers)
            // TODO: interceptors for token
          ]);
    }
    return _chopperClient;
  }
}
