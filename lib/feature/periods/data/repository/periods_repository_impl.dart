import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_local_datasource.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_remote_datasource.dart';
import 'package:registro_elettronico/feature/periods/domain/model/period_domain_model.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:dartz/dartz.dart';
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
    try {} catch (e, s) {
      return Left(handleError(e));
    }
  }
}
