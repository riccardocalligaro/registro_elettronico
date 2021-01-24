import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/absences/data/model/absence_mapper.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsencesRepositoryImpl implements AbsencesRepository {
  final SpaggiariClient spaggiariClient;
  final AbsenceDao absenceDao;
  final ProfilesLocalDatasource profilesLocalDatasource;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final AuthenticationRepository authenticationRepository;

  AbsencesRepositoryImpl(
    this.spaggiariClient,
    this.absenceDao,
    this.profilesLocalDatasource,
    this.networkInfo,
    this.sharedPreferences,
    this.authenticationRepository,
  );

  @override
  Future updateAbsences() async {
    if (await networkInfo.isConnected) {
      Logger.info('Updating absences');

      final studentId = await authenticationRepository.getCurrentStudentId();
      final absences = await spaggiariClient.getAbsences(studentId);
      List<Absence> absencesList = [];
      absences.events.forEach((event) {
        absencesList.add(AbsenceMapper.convertEventEntityToInsertable(event));
      });
      Logger.info(
        'Got ${absences.events.length} events from server, procceding to insert in database',
      );

      await absenceDao.deleteAllAbsences();

      await absenceDao.insertEvents(absencesList);

      await sharedPreferences.setInt(
        PrefsConstants.lastUpdateAbsences,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future insertEvent(Absence absence) {
    return absenceDao.insertEvent(absence);
  }

  @override
  Stream<List<Absence>> watchAllAbsences() {
    return absenceDao.watchAllAbsences();
  }

  @override
  Future<List<Absence>> getAllAbsences() {
    return absenceDao.getAllAbsences();
  }

  @override
  Future deleteAllAbsences() {
    return absenceDao.deleteAllAbsences();
  }
}
