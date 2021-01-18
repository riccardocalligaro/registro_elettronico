import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_local_datasource.dart';

import 'package:registro_elettronico/feature/grades/data/repository/grades_repository_impl.dart';
import 'package:registro_elettronico/feature/grades/presentation/updater/grades_updater_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/watcher/grades_watcher_bloc.dart';

import 'data/datasource/normal/grades_remote_datasource.dart';
import 'domain/repository/grades_repository.dart';

final sl = GetIt.instance;

class GradesContainer {
  static Future<void> init() async {
    sl.registerLazySingleton(
      () => GradesLocalDatasource(sl()),
    );
    sl.registerLazySingleton(
      () => GradesRemoteDatasource(
        dio: sl(),
        profileRepository: sl(),
      ),
    );

    sl.registerLazySingleton<GradesRepository>(
      () => GradesRepositoryImpl(
        networkInfo: sl(),
        gradesRemoteDatasource: sl(),
        gradesLocalDatasource: sl(),
        sharedPreferences: sl(),
        periodDao: sl(),
        subjectDao: sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<GradesWatcherBloc>(
        create: (BuildContext context) => GradesWatcherBloc(
          gradesRepository: sl(),
        ),
      ),
      BlocProvider<GradesUpdaterBloc>(
        create: (BuildContext context) => GradesUpdaterBloc(
          gradesRepository: sl(),
        ),
      ),
    ];
  }
}
