import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pedantic/pedantic.dart';
import 'package:registro_elettronico/core/data/remote/api/sr_api_config.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/authentication/presentation/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey();

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
    final _dio = Dio();

    _dio.options.headers["Content-Type"] = Headers.jsonContentType;
    _dio.options.headers["User-Agent"] = "${SRApiConfig.baseUserAgent}";
    _dio.options.headers["Z-Dev-Apikey"] = "${SRApiConfig.apiKey}";

    _dio.options.baseUrl = 'https://web.spaggiari.eu/rest/v1';

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          // Replace the student id with the current profile student id
          if (options.path.contains('{studentId}')) {
            final studentId =
                await authenticationRepository.getCurrentStudentId();

            final replaced = options.path.replaceAll(
              '{studentId}',
              studentId,
            );
            options.path = replaced;
          }

          if (options.path != SRApiConfig.loginPath) {
            _dio.lock();

            // get the profile from the database
            final profile = await authenticationRepository.getProfile();

            //? This checks if the profile exires before now, so if this  results true the token is expired
            if (profile.expire.isBefore(DateTime.now()) ||
                profile == null ||
                profile.token.isEmpty) {
              Logger.info(
                '🔒 [DioINTERCEPTOR] Need to request new token - ${profile.expire.toString()}',
              );

              // Read the password from the secure storage
              final password = await flutterSecureStorage.read(
                key: profile.ident,
              );

              final _tokenDio = Dio();
              _tokenDio.options.baseUrl = "${SRApiConfig.baseApiUrl}";
              _tokenDio.options.headers["Content-Type"] =
                  Headers.jsonContentType;
              _tokenDio.options.headers["User-Agent"] =
                  "${SRApiConfig.baseUserAgent}";
              _tokenDio.options.headers["Z-Dev-Apikey"] =
                  "${SRApiConfig.apiKey}";

              _tokenDio.interceptors.add(
                InterceptorsWrapper(
                  onError: (DioError error) async {
                    if (error.response != null &&
                        error.response.statusCode == 422) {
                      await authenticationRepository.logoutCurrentUser();
                      await flutterSecureStorage.write(
                          key: profile.ident, value: '');
                      unawaited(navigator.currentState.pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      ));
                      return null;
                    }
                    Logger.e(text: error.toString());
                  },
                ),
              );

              // we make a request to auth login to get the new token
              final res = await _tokenDio.post(SRApiConfig.loginPath, data: {
                'ident': profile.ident,
                'pass': password,
                'uid': profile.ident
              });

              final loginResponse = DefaultLoginResponseRemoteModel.fromJson(
                res.data,
              );

              // Update the profile with the new login response
              await authenticationRepository.updateProfile(
                responseRemoteModel: loginResponse,
                profileDomainModel: profile,
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
            _dio.unlock();
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

    return _dio;
  }
}
