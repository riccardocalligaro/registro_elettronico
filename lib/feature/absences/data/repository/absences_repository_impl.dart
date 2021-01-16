import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/absences/data/model/absence_mapper.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsencesRepositoryImpl implements AbsencesRepository {
  final SpaggiariClient spaggiariClient;
  final AbsenceDao absenceDao;
  final ProfileDao profileDao;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final ProfileRepository profileRepository;

  AbsencesRepositoryImpl(
    this.spaggiariClient,
    this.absenceDao,
    this.profileDao,
    this.networkInfo,
    this.sharedPreferences,
    this.profileRepository,
  );

  @override
  Future updateAbsences() async {
    if (await networkInfo.isConnected) {
      Logger.info('Updating absences');

      final profile = await profileRepository.getProfile();
      final absences = await spaggiariClient.getAbsences(profile.studentId);
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
