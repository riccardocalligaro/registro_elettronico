import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';

abstract class PeriodsRepository {
  Future<Either<Failure, Success>> updatePeriods({@required bool ifNeeded});
}
