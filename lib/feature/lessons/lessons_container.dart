import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:registro_elettronico/feature/lessons/data/repository/lessons_repository_impl.dart';
import 'package:registro_elettronico/feature/lessons/presentation/latest_watcher/latest_lessons_watcher_bloc.dart';
import 'package:registro_elettronico/feature/lessons/presentation/watcher/lessons_watcher_bloc.dart';

import 'data/datasource/lessons_local_datasource.dart';
import 'data/datasource/lessons_remote_datasource.dart';
import 'domain/repository/lessons_repository.dart';

final _sl = GetIt.instance;

class LessonsContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => LessonsLocalDatasource(_sl()),
    );

    _sl.registerLazySingleton(
      () => LessonsRemoteDatasource(
        dio: _sl(),
      ),
    );

    _sl.registerLazySingleton<LessonsRepository>(
      () => LessonsRepositoryImpl(
        lessonsRemoteDatasource: _sl(),
        lessonsLocalDatasource: _sl(),
        sharedPreferences: _sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<LessonsWatcherBloc>(
        create: (BuildContext context) => LessonsWatcherBloc(
          lessonsRepository: _sl(),
        ),
      ),
      BlocProvider<LatestLessonsWatcherBloc>(
        create: (BuildContext context) => LatestLessonsWatcherBloc(
          lessonsRepository: _sl(),
        ),
      ),
    ];
  }
}
