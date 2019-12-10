import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/component/api_config.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/login_response.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';

class DioClient {
  final ProfileMapper profileMapper;
  final ProfileRepository profileRepository;
  final FlutterSecureStorage flutterSecureStorage;

  DioClient(
      this.profileMapper, this.profileRepository, this.flutterSecureStorage);

  Dio createDio() {
    final dio = Dio();

    dio.options.headers["Content-Type"] = Headers.jsonContentType;
    dio.options.headers["User-Agent"] = "${ApiConfig.BASE_USER_AGENT}";
    dio.options.headers["Z-Dev-Apikey"] = "${ApiConfig.API_KEY}";

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      //? We need to add the token when we are not loggin in
      if (options.path != "/auth/login") {
        // temporarily lock the requests
        dio.lock();
        // get the profile from the database
        final profile = await profileRepository.getDbProfile();

        //? This checks if the profile exires before now, so if this  results true the token is expired
        if (profile.expire.isBefore(DateTime.now())) {
          print("NEED TO REQUEST NEW TOKEN!");
          // this gets the password from flutter secure storage which is saved using the ident
          final password = await flutterSecureStorage.read(key: profile.ident);
          // we create a dio client for requesting the token to spaggiari
          final tokenDio = Dio();
          tokenDio.options.baseUrl = "${ApiConfig.BASE_API_URL}";
          tokenDio.options.headers["Content-Type"] = Headers.jsonContentType;
          tokenDio.options.headers["User-Agent"] =
              "${ApiConfig.BASE_USER_AGENT}";
          tokenDio.options.headers["Z-Dev-Apikey"] = "${ApiConfig.API_KEY}";

          // we make a request to auth login to get the new token
          final request = await tokenDio.post("/auth/login", data: {
            "ident": profile.ident,
            "pass": password,
            "uid": profile.ident
          });

          // this converts the response data to a login response
          final loginResponse = LoginResponse.fromJson(request.data);

          // finally we update the db with the new token
          profileRepository.updateProfile(profileMapper
              .mapLoginResponseProfileToProfileEntity(loginResponse));

          //profileRepository.updateProfile();
          print("${request.statusCode} GOT NEW TOKEN! ${loginResponse.token}");
          // this sets the token as the new one we just got from the api
          options.headers["Z-Auth-Token"] = loginResponse.token;
        } else {
          print("NO NEED FOR TOKEN!");
          // If the token is still vaid we just use the one we got from the database
          options.headers["Z-Auth-Token"] = profile.token;
        }
        // unlock and proceed
        dio.unlock();
      }

      return options;
    }, onResponse: (Response response) {
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioEND\tonResponse \t${response.statusCode} [${response.request.path}] ${response.request.method}  ${response.request.responseType}");
      // print(response.data);
      print(response.request.headers.toString());

      return response; // continue
    }, onError: (DioError error) async {
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioEND\tonError \turl:[${error.request.baseUrl}] type:${error.type} message: ${error.message}");
      print("HEADERS SENT" + error.request.headers.toString());

      print("DATA RECIEVED" + error.response.statusMessage);
      // handlError(error);
    }));
    return dio;
  }
}
