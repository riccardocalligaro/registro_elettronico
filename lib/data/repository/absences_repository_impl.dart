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
  AbsenceMapper absenceMapper;

  AbsencesRepositoryImpl(this.spaggiariClient, this.absenceDao, this.profileDao,
      this.absenceMapper);

  @override
  Future updateAbsences() async {
    final profile = await profileDao.getProfile();
    final absences = await spaggiariClient.getAbsences(profile.studentId);
    absences.events.forEach((event) {
      absenceDao
          .insertEvent(absenceMapper.convertEventEntityToInsertable(event));
    });
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
}
