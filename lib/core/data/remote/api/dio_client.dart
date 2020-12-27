import 'dart:io';

import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/component/api_config.dart';
import 'package:registro_elettronico/core/infrastructure/exception/server_exception.dart';
import 'package:registro_elettronico/feature/profile/data/model/profile_mapper.dart';
import 'package:registro_elettronico/feature/login/data/model/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';

class DioClient {
  final ProfileRepository profileRepository;
  final FlutterSecureStorage flutterSecureStorage;

  DioClient(this.profileRepository, this.flutterSecureStorage);

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
        FLog.info(text: 'Got profile');
        //? This checks if the profile exires before now, so if this  results true the token is expired
        if (profile.expire.isBefore(DateTime.now())) {
          FLog.info(
            text: "Need to request new token - ${profile.expire.toString()}",
          );
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
          final res = await tokenDio.post("/auth/login", data: {
            "ident": profile.ident,
            "pass": password,
            "uid": profile.ident
          });

          if (res.statusCode != 200) {
            throw ServerException.fromJson(res.data);
          }

          // this converts the response data to a login response
          final loginResponse = LoginResponse.fromJson(res.data);

          // finally we update the db with the new token
          profileRepository.updateProfile(
              ProfileMapper.mapLoginResponseProfileToProfileEntity(
            loginResponse,
          ));

          //profileRepository.updateProfile();
          FLog.info(
            text: "Got a new token - proceeding with request",
          );
          // this sets the token as the new one we just got from the api
          options.headers["Z-Auth-Token"] = loginResponse.token;
        } else {
          FLog.info(
            text: "No need for token - proceeding with request",
          );
          // If the token is still vaid we just use the one we got from the database
          options.headers["Z-Auth-Token"] = profile.token;
        }
        // unlock and proceed
        dio.unlock();
      }

      return options;
    }, onResponse: (Response response) {
      FLog.info(
        text:
            'DioEND -> Response -> ${response.statusCode} [${response.request.path}] ${response.request.method}  ${response.request.responseType}',
      );

      return response; // continue
    }, onError: (DioError error) async {
      FLog.error(
        text:
            'DioEND -> Error -> url:[${error.request.baseUrl}] type:${error.type} message: ${error.message}',
      );

      if (error != SocketException) {
        FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
      }

      // handlError(error);
    }));
    return dio;
  }
}
