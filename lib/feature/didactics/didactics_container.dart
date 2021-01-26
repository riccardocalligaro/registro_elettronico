import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/didactics/data/repository/didactics_repository_impl.dart';
import 'package:registro_elettronico/feature/didactics/presentation/attachment/didactics_attachment_bloc.dart';

import 'package:registro_elettronico/feature/didactics/presentation/watcher/didactics_watcher_bloc.dart';

import 'data/datasource/didactics_local_datasource.dart';
import 'data/datasource/didactics_remote_datasource.dart';
import 'data/repository/didactics_repository_impl.dart';
import 'domain/repository/didactics_repository.dart';

final _sl = GetIt.instance;

class DidacticsContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => DidacticsLocalDatasource(_sl()),
    );

    _sl.registerLazySingleton(
      () => DidacticsRemoteDatasource(
        dio: _sl(),
      ),
    );

    _sl.registerLazySingleton<DidacticsRepository>(
      () => DidacticsRepositoryImpl(
        didacticsRemoteDatasource: _sl(),
        didacticsLocalDatasource: _sl(),
        sharedPreferences: _sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<DidacticsWatcherBloc>(
        create: (BuildContext context) => DidacticsWatcherBloc(
          didacticsRepository: _sl(),
        ),
      ),
      BlocProvider<DidacticsAttachmentBloc>(
        create: (BuildContext context) => DidacticsAttachmentBloc(
          didacticsRepository: _sl(),
        ),
      ),
    ];
  }
}
