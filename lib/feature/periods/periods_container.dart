import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_local_datasource.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_remote_datasource.dart';
import 'package:registro_elettronico/feature/periods/data/repository/periods_repository_impl.dart';

import 'data/repository/periods_repository_impl.dart';
import 'domain/repository/periods_repository.dart';

final _sl = GetIt.instance;

class PeriodsContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => PeriodsLocalDatasource(_sl()),
    );

    _sl.registerLazySingleton(
      () => PeriodsRemoteDatasource(
        dio: _sl(),
      ),
    );

    _sl.registerLazySingleton<PeriodsRepository>(
      () => PeriodsRepositoryImpl(
        periodsRemoteDatasource: _sl(),
        periodsLocalDatasource: _sl(),
        sharedPreferences: _sl(),
      ),
    );
  }
}
