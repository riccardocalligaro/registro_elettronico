import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/subjects/data/datasource/subject_remote_datasource.dart';
import 'package:registro_elettronico/feature/subjects/data/repository/subjects_repository_impl.dart';
import 'package:registro_elettronico/feature/subjects/presentation/watcher/subjects_watcher_bloc.dart';

import 'data/datasource/subject_local_datasource.dart';
import 'domain/repository/subjects_repository.dart';

final _sl = GetIt.instance;

class SubjectsContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => SubjectsLocalDatasource(_sl()),
    );

    _sl.registerLazySingleton(
      () => SubjectsRemoteDatasource(
        dio: _sl(),
      ),
    );

    _sl.registerLazySingleton<SubjectsRepository>(
      () => SubjectsRepositoryImpl(
        subjectsRemoteDatasource: _sl(),
        subjectsLocalDatasource: _sl(),
        sharedPreferences: _sl(),
        professorLocalDatasource: _sl(),
        lessonsLocalDatasource: _sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<SubjectsWatcherBloc>(
        create: (BuildContext context) => SubjectsWatcherBloc(
          subjectsRepository: _sl(),
        ),
      ),
    ];
  }
}
