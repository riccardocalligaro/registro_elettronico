import 'package:dio/dio.dart';
import 'package:registro_elettronico/core/data/remote/api/api_config.dart';

class SRAuthenticationClient {
  static Dio createDio() {
    final dio = Dio();

    dio.options.headers["Content-Type"] = Headers.jsonContentType;
    dio.options.headers["User-Agent"] = "${ApiConfig.baseUserAgent}";
    dio.options.headers["Z-Dev-Apikey"] = "${ApiConfig.apiKey}";

    dio.options.baseUrl = 'https://web.spaggiari.eu/rest/v1';

    return dio;
  }
}
