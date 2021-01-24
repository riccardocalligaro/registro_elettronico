import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/core/data/remote/api/api_config.dart';
import 'package:registro_elettronico/core/infrastructure/exception/server_exception.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/authentication/presentation/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigator =
    GlobalKey(); //Create a key for navigator

class SRDioClient {
  final AuthenticationRepository authenticationRepository;
  final FlutterSecureStorage flutterSecureStorage;
  final SharedPreferences sharedPreferences;

  SRDioClient({
    @required this.authenticationRepository,
    @required this.flutterSecureStorage,
    @required this.sharedPreferences,
  });

  Dio createDio() {
    final dio = Dio();

    dio.options.headers["Content-Type"] = Headers.jsonContentType;
    dio.options.headers["User-Agent"] = "${ApiConfig.baseUserAgent}";
    dio.options.headers["Z-Dev-Apikey"] = "${ApiConfig.apiKey}";

    dio.options.baseUrl = 'https://web.spaggiari.eu/rest/v1';

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          //? We need to add the token when we are not loggin in

          if (options.path.contains('{studentId}')) {
            final studentId =
                await authenticationRepository.getCurrentStudentId();

            final replaced = options.path.replaceAll(
              '{studentId}',
              studentId,
            );
            options.path = replaced;
          }
          if (options.path != "/auth/login") {
            // temporarily lock the requests
            dio.lock();
            // get the profile from the database
            final profile = await authenticationRepository.getProfile();

            final expireDate = profile.expire;

            //? This checks if the profile exires before now, so if this  results true the token is expired
            if (expireDate.isBefore(DateTime.now()) || profile.token == "") {
              Logger.info(
                '🔒 [DioINTERCEPTOR] Need to request new token - ${profile.expire.toString()}',
              );
              // this gets the password from flutter secure storage which is saved using the ident
              final password =
                  await flutterSecureStorage.read(key: profile.ident);

              // we create a dio client for requesting the token to spaggiari
              final tokenDio = Dio();
              tokenDio.options.baseUrl = "${ApiConfig.baseApiUrl}";
              tokenDio.options.headers["Content-Type"] =
                  Headers.jsonContentType;
              tokenDio.options.headers["User-Agent"] =
                  "${ApiConfig.baseUserAgent}";
              tokenDio.options.headers["Z-Dev-Apikey"] = "${ApiConfig.apiKey}";

              tokenDio.interceptors.add(
                InterceptorsWrapper(
                  onError: (DioError error) async {
                    if (error.response != null &&
                        error.response.statusCode == 422) {
                      await flutterSecureStorage.deleteAll();
                      await sharedPreferences.clear();
                      // ignore: unawaited_futures
                      navigator.currentState.pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );

                      return null;
                    }
                    Logger.e(text: error.toString());
                  },
                ),
              );

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
              final loginResponse =
                  DefaultLoginResponseRemoteModel.fromJson(res.data);

              // finally we update the db with the new token

              await authenticationRepository.updateProfile(
                responseRemoteModel: loginResponse,
              );

              Logger.info(
                '🔒 [DioINTERCEPTOR] Got a new token - proceeding with request',
              );
              // this sets the token as the new one we just got from the api
              options.headers["Z-Auth-Token"] = loginResponse.token;
            } else {
              Logger.info(
                '🆓 [DioINTERCEPTOR] No need for token - proceeding with request',
              );
              // If the token is still vaid we just use the one we got from the database
              options.headers["Z-Auth-Token"] = profile.token;
            }
            // unlock and proceed
            dio.unlock();
          }

          return options;
        },
        onResponse: (Response response) {
          Logger.info(
            '🌐 [DioEND] -> Response -> ${response.statusCode} [${response.request.path}] ${response.request.method}  ${response.request.responseType}',
          );

          return response; // continue
        },
        onError: (DioError error) async {
          if (error.response == null) {
            Logger.streamError(error.toString());
          } else {
            Logger.networkError(
              '🤮 [DioERROR] ${error.type} Url: [${error.request.baseUrl}${error.request.path}] status:${error.response.statusCode} type:${error.type} Data: ${error.response.data} message: ${error.message}',
            );
          }
          return error;
        },
      ),
    );
    return dio;
  }
}
