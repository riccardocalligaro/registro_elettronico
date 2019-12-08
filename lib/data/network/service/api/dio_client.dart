import 'package:dio/dio.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';

class DioClient {
  final ProfileRepository profileRepository;

  DioClient(this.profileRepository);

  Dio createDio() {
    final dio = Dio();

    dio.options.headers["Content-Type"] = Headers.jsonContentType;
    dio.options.headers["User-Agent"] = "zorro/1.0";
    dio.options.headers["Z-Dev-Apikey"] = "+zorro+";

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      print(options.path);
      if (options.path != '/auth/login') {
        //! to check
        dio.interceptors.requestLock.lock();
        final token = await profileRepository.getToken();

        // TODO: need to verify if the token is still valid, if not it should request new one
        dio.options.headers["Z-Auth-Token"] = token;
        print("TOKEN FOR REQUESRT $token");
        dio.interceptors.requestLock.unlock();
        // print(dio.options.headers);
        return options;
        // final token = await
      }
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioSTART\tonRequest \t${options.method} [${options.path}] ${options.contentType}");
      return options; //continue
    }, onResponse: (Response response) {
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioEND\tonResponse \t${response.statusCode} [${response.request.path}] ${response.request.method}  ${response.request.responseType}");
      print(response.data);
      return response; // continue
    }, onError: (DioError error) async {
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioEND\tonError \turl:[${error.request.baseUrl}] type:${error.type} message: ${error.message}");
      // handlError(error);
    }));
    return dio;
  }
}
