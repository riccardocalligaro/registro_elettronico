import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/timetable/data/repository/timetable_repository_impl.dart';
import 'package:registro_elettronico/feature/timetable/presentation/watcher/timetable_watcher_bloc.dart';

import 'data/datasource/timetable_local_datasource.dart';
import 'domain/repository/timetable_repository.dart';

final _sl = GetIt.instance;

class TimetableContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => TimetableLocalDatasource(_sl()),
    );

    _sl.registerLazySingleton<TimetableRepository>(
      () => TimetableRepositoryImpl(
        timetableLocalDatasource: _sl(),
        lessonsLocalDatasource: _sl(),
        subjectsLocalDatasource: _sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<TimetableWatcherBloc>(
        create: (BuildContext context) => TimetableWatcherBloc(
          timetableRepository: _sl(),
        ),
      ),
    ];
  }
}
