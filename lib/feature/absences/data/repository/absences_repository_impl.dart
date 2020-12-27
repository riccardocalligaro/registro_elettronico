import 'package:f_logs/f_logs.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/absences/data/model/absence_mapper.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';

class AbsencesRepositoryImpl implements AbsencesRepository {
  SpaggiariClient spaggiariClient;
  AbsenceDao absenceDao;
  ProfileDao profileDao;
  NetworkInfo networkInfo;

  AbsencesRepositoryImpl(
    this.spaggiariClient,
    this.absenceDao,
    this.profileDao,
    this.networkInfo,
  );

  @override
  Future updateAbsences() async {
    if (await networkInfo.isConnected) {
      FLog.info(text: 'Updating absences');

      final profile = await profileDao.getProfile();
      final absences = await spaggiariClient.getAbsences(profile.studentId);
      List<Absence> absencesList = [];
      absences.events.forEach((event) {
        absencesList.add(AbsenceMapper.convertEventEntityToInsertable(event));
      });
      FLog.info(
        text:
            'Got ${absences.events.length} events from server, procceding to insert in database',
      );

      await absenceDao.deleteAllAbsences();

      absenceDao.insertEvents(absencesList);
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
