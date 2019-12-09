import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';

class DioClient {
  final ProfileMapper profileMapper;
  final ProfileRepository profileRepository;
  final FlutterSecureStorage flutterSecureStorage;

  DioClient(
      this.profileMapper, this.profileRepository, this.flutterSecureStorage);

  Dio createDio() {
    final dio = Dio();
    final tokenDio = Dio();

    dio.options.headers["Content-Type"] = Headers.jsonContentType;
    dio.options.headers["User-Agent"] = "zorro/1.0";
    dio.options.headers["Z-Dev-Apikey"] = "+zorro+";

    tokenDio.options = dio.options;

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      print(options.path);
      if (options.path != '/auth/login') {
        final profile = await profileRepository.getDbProfile();

        if (profile.expire.isBefore(DateTime.now())) {
          // lock all the requests
          // TODO: fix this bug Invalid value: Only valid value is 0: 1
          dio.interceptors.requestLock.lock();

          //dio.lock();
          print("--- START OF REQUESTING A NEW TOKEN ---");
          // gets the profile from the database
          final profileDb = await profileRepository.getDbProfile();
          // gets the password from secure storage
          //final password =
          //    await flutterSecureStorage.read(key: profileDb.passwordKey);
          return tokenDio.post("/auth/login", data: {
            "ident": profileDb.ident,
            "pass": "sd",
            "uid": profileDb.ident
          }).then((d) {
            print("made request");
            final profileEntity =
                profileMapper.mapLoginResponseProfileToProfileEntity(d.data);
            // set the new token as a header
            dio.options.headers["Z-Auth-Token"] = profileEntity.token;
            // last thing we need to do is to update the database with the new profile
            profileRepository.updateProfile(profileEntity);

            print("--- END OF REQUESTING A NEW TOKEN ---");
          }).whenComplete(() => dio.interceptors.requestLock.unlock());
          // We unlock the interceptor when we have finished the chain
        } else {
          // if the token that we have is still valid we simply use the current that we have from the database
          print("THE TOKEN IS VALID!");
        }
        dio.options.headers["Z-Auth-Token"] = profile.token;

        return options;
      }
      print(
          "[AppApiService][${DateTime.now().toString().split(' ').last}]-> DioSTART\tonRequest \t${options.method} [${options.path}] ${options.contentType}");

      return options; //continue
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
