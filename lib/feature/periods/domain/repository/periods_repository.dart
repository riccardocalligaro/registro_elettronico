import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';

abstract class PeriodsRepository {
  Future<Either<Failure, bool>> needToUpdatePeriods();

  Future<Either<Failure, Success>> updatePeriods({required bool ifNeeded});
}
