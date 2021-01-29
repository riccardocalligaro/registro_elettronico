import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/absences/data/repository/absences_repository_impl.dart';
import 'package:registro_elettronico/feature/absences/presentation/bloc/absences_bloc.dart';

import 'data/datasource/absences_remote_datasource.dart';
import 'domain/repository/absences_repository.dart';

final _sl = GetIt.instance;

class AbsencesContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => AbsenceDao(_sl()),
    );

    _sl.registerLazySingleton(
      () => AbsencesRemoteDatasource(
        dio: _sl(),
      ),
    );

    _sl.registerLazySingleton<AbsencesRepository>(
      () => AbsencesRepositoryImpl(
        absenceDao: _sl(),
        absencesRemoteDatasource: _sl(),
        sharedPreferences: _sl(),
        networkInfo: _sl(),
        profilesLocalDatasource: _sl(),
        authenticationRepository: _sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<AbsencesBloc>(
        create: (ctx) => AbsencesBloc(
          absencesRepository: _sl(),
        ),
      ),
    ];
  }
}
