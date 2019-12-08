import 'package:dio/dio.dart';

class DioClient {
  Dio createDio() {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["User-Agent"] = "zorro/1.0";
    dio.options.headers["Z-Dev-Apikey"] = "+zorro+";

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioSTART\tonRequest \t${options.method} [${options.path}] ${options.contentType}");
      return options; //continue
    }, onResponse: (Response response) {
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioEND\tonResponse \t${response.statusCode} [${response.request.path}] ${response.request.method}  ${response.request.responseType}");
      return response; // continue
    }, onError: (DioError error) async {
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioEND\tonError \turl:[${error.request.baseUrl}] type:${error.type} message: ${error.message}");
      // handlError(error);
    }));
    return dio;
  }
}
