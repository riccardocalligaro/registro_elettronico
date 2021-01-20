import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/agenda/data/repository/agenda_repository_impl.dart';
import 'package:registro_elettronico/feature/agenda/presentation/bloc/agenda_updater_bloc.dart';
import 'package:registro_elettronico/feature/agenda/presentation/watcher/agenda_watcher_bloc.dart';

import 'data/datasource/local/agenda_local_datasource.dart';
import 'data/datasource/remote/agenda_remote_datasource.dart';
import 'data/repository/agenda_repository_impl.dart';
import 'domain/repository/agenda_repository.dart';

final sl = GetIt.instance;

class AgendaContainer {
  static Future<void> init() async {
    sl.registerLazySingleton(
      () => AgendaLocalDatasource(sl()),
    );

    sl.registerLazySingleton(
      () => AgendaRemoteDatasource(
        dio: sl(),
        profileRepository: sl(),
      ),
    );

    sl.registerLazySingleton<AgendaRepository>(
      () => AgendaRepositoryImpl(
        agendaRemoteDatasource: sl(),
        agendaLocalDatasource: sl(),
        sharedPreferences: sl(),
        lessonDao: sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<AgendaWatcherBloc>(
        create: (BuildContext context) => AgendaWatcherBloc(
          agendaRepository: sl(),
        ),
      ),
      BlocProvider<AgendaUpdaterBloc>(
        create: (BuildContext context) => AgendaUpdaterBloc(
          agendaRepository: sl(),
        ),
      ),
    ];
  }
}
