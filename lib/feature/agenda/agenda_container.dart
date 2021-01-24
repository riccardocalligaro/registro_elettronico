import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/agenda/data/repository/agenda_repository_impl.dart';
import 'package:registro_elettronico/feature/agenda/presentation/updater/agenda_updater_bloc.dart';
import 'package:registro_elettronico/feature/agenda/presentation/watcher/agenda_watcher_bloc.dart';

import 'data/datasource/local/agenda_local_datasource.dart';
import 'data/datasource/remote/agenda_remote_datasource.dart';
import 'data/repository/agenda_repository_impl.dart';
import 'domain/repository/agenda_repository.dart';

final _sl = GetIt.instance;

class AgendaContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => AgendaLocalDatasource(_sl()),
    );

    _sl.registerLazySingleton(
      () => AgendaRemoteDatasource(
        dio: _sl(),
        authenticationRepository: _sl(),
      ),
    );

    _sl.registerLazySingleton<AgendaRepository>(
      () => AgendaRepositoryImpl(
        agendaRemoteDatasource: _sl(),
        agendaLocalDatasource: _sl(),
        sharedPreferences: _sl(),
        lessonsLocalDatasource: _sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<AgendaWatcherBloc>(
        create: (BuildContext context) => AgendaWatcherBloc(
          agendaRepository: _sl(),
        ),
      ),
      BlocProvider<AgendaUpdaterBloc>(
        create: (BuildContext context) => AgendaUpdaterBloc(
          agendaRepository: _sl(),
        ),
      ),
    ];
  }
}
