import 'package:f_logs/f_logs.dart';
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
    await periodDao.deleteAllPeriods();
    List<Period> periodsList = [];
    int periodIndex = 1;
    periods.periods.forEach((period) {
      periodsList.add(
          periodMapper.convertEventEntityToInsertable(period, periodIndex));
      periodIndex++;
    });

    FLog.info(
      text:
          'Got ${periods.periods.length} periods from server, procceding to insert in database',
    );
    periodDao.insertPeriods(periodsList);
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
