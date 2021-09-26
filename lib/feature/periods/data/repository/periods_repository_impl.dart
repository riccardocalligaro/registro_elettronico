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

  final PeriodsLocalDatasource? periodsLocalDatasource;
  final PeriodsRemoteDatasource? periodsRemoteDatasource;
  final SharedPreferences? sharedPreferences;

  PeriodsRepositoryImpl({
    required this.periodsLocalDatasource,
    required this.periodsRemoteDatasource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, Success>> updatePeriods({required bool ifNeeded}) async {
    try {
      if (!ifNeeded |
          (ifNeeded && needUpdate(sharedPreferences!.getInt(lastUpdateKey)))) {
        final remotePeriods = await periodsRemoteDatasource!.getPeriods();

        final List<PeriodLocalModel> remoteConvertedPeriods =
            remotePeriods.asMap().entries.map((entry) {
          return entry.value.toLocalModel(entry.key);
        }).toList();

        // delete the periods that were removed from the remote source
        await periodsLocalDatasource!.deleteAllPeriods();

        await periodsLocalDatasource!.insertPeriods(remoteConvertedPeriods);

        await sharedPreferences!.setInt(
            lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

        return Right(SuccessWithUpdate());
      }
      return Right(SuccessWithoutUpdate());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, bool>> needToUpdatePeriods() async {
    try {
      // controlliamo i periodi presenti nel db
      final periods = await periodsLocalDatasource!.getPeriods();

      if (periods.isEmpty) {
        return Right(true);
      }

      periods.sort((a, b) => a.position!.compareTo(b.position!));

      final today = DateTime.now();

      if (periods.last.end!.isBefore(today)) {
        return Right(true);
      }

      return Right(false);
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}
