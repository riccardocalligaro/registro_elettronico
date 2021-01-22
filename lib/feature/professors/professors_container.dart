import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/professors/data/datasource/professor_remote_datasource.dart';
import 'package:registro_elettronico/feature/professors/data/repository/professors_repository_impl.dart';
import 'package:registro_elettronico/feature/professors/presentation/watcher/professors_watcher_bloc.dart';

import 'data/datasource/professor_local_datasource.dart';
import 'data/datasource/professors_local_datasource.dart';
import 'domain/repository/professors_repository.dart';

final _sl = GetIt.instance;

class ProfessorsContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => ProfessorLocalDatasource(_sl()),
    );
  }
}
