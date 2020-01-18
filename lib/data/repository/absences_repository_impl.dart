import 'package:f_logs/f_logs.dart';
import 'package:registro_elettronico/data/db/dao/absence_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/absence_mapper.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';

class AbsencesRepositoryImpl implements AbsencesRepository {
  SpaggiariClient spaggiariClient;
  AbsenceDao absenceDao;
  ProfileDao profileDao;

  AbsencesRepositoryImpl(
    this.spaggiariClient,
    this.absenceDao,
    this.profileDao,
  );

  @override
  Future updateAbsences() async {
    FLog.info(text: 'Updating absences');
    final profile = await profileDao.getProfile();
    await absenceDao.deleteAllAbsences();
    final absences = await spaggiariClient.getAbsences(profile.studentId);
    List<Absence> absencesList = [];
    absences.events.forEach((event) {
      absencesList.add(AbsenceMapper.convertEventEntityToInsertable(event));
    });
    FLog.info(
      text:
          'Got ${absences.events.length} events from server, procceding to insert in database',
    );
    absenceDao.insertEvents(absencesList);
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
