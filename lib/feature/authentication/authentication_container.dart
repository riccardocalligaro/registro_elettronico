import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_local_datasource.dart';
import 'package:registro_elettronico/feature/authentication/data/repository/authentication_repository_impl.dart';
import 'package:registro_elettronico/feature/authentication/presentation/bloc/authentication_bloc.dart';

import 'data/datasource/authentication_dio.dart';
import 'data/datasource/authentication_remote_datasource.dart';
import 'data/repository/authentication_repository_impl.dart';
import 'domain/repository/authentication_repository.dart';

final _sl = GetIt.instance;

class AuthenticationContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => ProfilesLocalDatasource(_sl()),
    );

    _sl.registerLazySingleton(
      () => AuthenticationRemoteDatasource(
        dio: SRAuthenticationClient.createDio(),
      ),
    );

    _sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
        authenticationRemoteDatasource: _sl(),
        profilesLocalDatasource: _sl(),
        sharedPreferences: _sl(),
        flutterSecureStorage: _sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => AuthenticationBloc(
          authenticationRepository: _sl(),
        ),
      ),
    ];
  }
}
