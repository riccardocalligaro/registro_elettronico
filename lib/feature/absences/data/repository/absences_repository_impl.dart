import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/absences/data/datasource/absences_remote_datasource.dart';
import 'package:registro_elettronico/feature/absences/data/model/absence_mapper.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsencesRepositoryImpl implements AbsencesRepository {
  final AbsenceDao? absenceDao;
  final ProfilesLocalDatasource? profilesLocalDatasource;
  final NetworkInfo? networkInfo;
  final SharedPreferences? sharedPreferences;
  final AuthenticationRepository? authenticationRepository;
  final AbsencesRemoteDatasource? absencesRemoteDatasource;

  AbsencesRepositoryImpl({
    required this.absencesRemoteDatasource,
    required this.absenceDao,
    required this.profilesLocalDatasource,
    required this.networkInfo,
    required this.sharedPreferences,
    required this.authenticationRepository,
  });

  @override
  Future updateAbsences() async {
    if (await networkInfo!.isConnected) {
      Fimber.i('[AbsencesRepository] Updating absences');

      final absences = await absencesRemoteDatasource!.getAbsences();
      List<Absence> absencesList = [];
      absences.forEach((event) {
        absencesList.add(AbsenceMapper.convertEventEntityToInsertable(event));
      });

      Fimber.i(
        '[AbsencesRepository] Got ${absences.length} events from server, procceding to insert in database',
      );

      await absenceDao!.deleteAllAbsences();

      await absenceDao!.insertEvents(absencesList);

      await sharedPreferences!.setInt(
        PrefsConstants.lastUpdateAbsences,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future insertEvent(Absence absence) {
    return absenceDao!.insertEvent(absence);
  }

  @override
  Stream<List<Absence>> watchAllAbsences() {
    return absenceDao!.watchAllAbsences();
  }

  @override
  Future<List<Absence>> getAllAbsences() {
    return absenceDao!.getAllAbsences();
  }

  @override
  Future deleteAllAbsences() {
    return absenceDao!.deleteAllAbsences();
  }
}
