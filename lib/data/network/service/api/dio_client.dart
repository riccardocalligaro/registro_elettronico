import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    dio.options.headers["User-Agent"] = "zorro/1.0";
    dio.options.headers["Z-Dev-Apikey"] = "+zorro+";

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // TODO: add the interceptor to request a new token
      final profile = await profileRepository.getDbProfile();
      options.headers["Z-Auth-Token"] = profile.token;
      /*
      if (options.path != '/auth/login') {
        if (profile.expire.isAfter(DateTime.now())) {
          print("--- START OF REQUESTING A NEW TOKEN ---");
          final tokenDio = Dio();
          tokenDio.options.baseUrl = "https://web.spaggiari.eu/rest/v1";
          tokenDio.options.headers["Content-Type"] = Headers.jsonContentType;
          tokenDio.options.headers["User-Agent"] = "zorro/1.0";
          tokenDio.options.headers["Z-Dev-Apikey"] = "+zorro+";

          tokenDio.post("/auth/login", data: {
            "ident": profile.ident,
            "pass": "x9M*G3R03OT!Wv0z",
            "uid": profile.ident
          }).then((d) {
            print("made request");
            print("DATA RECIEVED: " + d.statusCode.toString());
            final loginResponse = LoginResponse.fromJson(d.data);
            final profileEntity = profileMapper
                .mapLoginResponseProfileToProfileEntity(loginResponse);
            // set the new token as a header
            dio.options.headers["Z-Auth-Token"] = profileEntity.token;
            print("NRE TOKEN+ " + loginResponse.token);
            // last thing we need to do is to update the database with the new profile
            profileRepository.updateProfile(profileEntity);
            dio.options.headers["Z-Auth-Token"] = "££££";

            print("--- END OF REQUESTING A NEW TOKEN ---");
          });
          //options.headers["Z-Auth-Token"]
        } else {
          options.headers["Z-Auth-Token"] = "%%%";
        }
        // need to insert the token
      }*/

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
