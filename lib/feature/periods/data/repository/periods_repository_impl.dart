import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_local_datasource.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_remote_datasource.dart';
import 'package:registro_elettronico/feature/periods/domain/repository/periods_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeriodsRepositoryImpl implements PeriodsRepository {
  static const String lastUpdateKey = 'periodsLastUpdate';

  final PeriodsLocalDatasource periodsLocalDatasource;
  final PeriodsRemoteDatasource periodsRemoteDatasource;
  final SharedPreferences sharedPreferences;

  PeriodsRepositoryImpl({
    @required this.periodsLocalDatasource,
    @required this.periodsRemoteDatasource,
    @required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, Success>> updatePeriods({bool ifNeeded}) async {
    try {
      if (!ifNeeded |
          (ifNeeded && needUpdate(sharedPreferences.getInt(lastUpdateKey)))) {
        final remotePeriods = await periodsRemoteDatasource.getPeriods();

        final List<PeriodLocalModel> remoteConvertedPeriods =
            remotePeriods.asMap().entries.map((entry) {
          return entry.value.toLocalModel(entry.key);
        }).toList();

        final localPeriods = await periodsLocalDatasource.getPeriods();

        // get the ids
        final remoteIds =
            remoteConvertedPeriods.map((e) => Tuple2(e.start, e.end)).toList();

        List<PeriodLocalModel> periodsToDelete = [];

        for (final localPeriod in localPeriods) {
          if (!remoteIds.contains(Tuple2(
            localPeriod.start,
            localPeriod.end,
          ))) {
            periodsToDelete.add(localPeriod);
          }
        }

        await periodsLocalDatasource.insertPeriods(remoteConvertedPeriods);

        // delete the periods that were removed from the remote source
        await periodsLocalDatasource.deletePeriods(periodsToDelete);

        await sharedPreferences.setInt(
            lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

        return Right(SuccessWithUpdate());
      }
      return Right(SuccessWithoutUpdate());
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
