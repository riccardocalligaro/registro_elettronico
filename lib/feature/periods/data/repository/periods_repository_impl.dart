import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/periods/data/dao/period_dao.dart';
import 'package:registro_elettronico/feature/periods/data/model/period_mapper.dart';
import 'package:registro_elettronico/feature/periods/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';

class PeriodsRepositoryImpl implements PeriodsRepository {
  final SpaggiariClient spaggiariClient;
  final PeriodDao periodDao;
  final ProfileDao profileDao;
  final NetworkInfo networkInfo;
  final ProfileRepository profileRepository;

  PeriodsRepositoryImpl(
    this.spaggiariClient,
    this.periodDao,
    this.profileDao,
    this.networkInfo,
    this.profileRepository,
  );

  @override
  Future updatePeriods() async {
    if (await networkInfo.isConnected) {
      final profile = await profileRepository.getProfile();
      final periods = await spaggiariClient.getPeriods(profile.studentId);
      List<Period> periodsList = [];
      int periodIndex = 1;
      periods.periods.forEach((period) {
        periodsList.add(
            PeriodMapper.convertEventEntityToInsertable(period, periodIndex));
        periodIndex++;
      });

      Logger.info(
        'Got ${periods.periods.length} periods from server, procceding to insert in database',
      );
      await periodDao.deleteAllPeriods();

      await periodDao.insertPeriods(periodsList);
    } else {
      throw NotConntectedException();
    }
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
