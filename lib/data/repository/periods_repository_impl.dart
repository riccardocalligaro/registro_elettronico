import 'package:registro_elettronico/data/db/dao/period_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/period_mapper.dart';
import 'package:registro_elettronico/domain/repository/periods_repository.dart';

class PeriodsRepositoryImpl implements PeriodsRepository {
  SpaggiariClient spaggiariClient;
  PeriodDao periodDao;
  ProfileDao profileDao;
  PeriodMapper periodMapper;

  PeriodsRepositoryImpl(
      this.spaggiariClient, this.periodDao, this.profileDao, this.periodMapper);

  @override
  Future updatePeriods() async {
    final profile = await profileDao.getProfile();
    final periods = await spaggiariClient.getPeriods(profile.studentId);
    periods.periods.forEach((period) {
      print(period.periodCode);
    });
    periods.periods.forEach((period) {
      periodDao
          .insertPeriod(periodMapper.convertEventEntityToInsertable(period));
    });
  }

  @override
  Future<List<Period>> getAllPeriods() async {
    return await periodDao.getAllPeriods();
  }

  @override
  Stream<List<Period>> watchAllPeriods() {
    return periodDao.watchAllPeriods();
  }
}
