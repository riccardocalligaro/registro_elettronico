import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';

abstract class ScrutiniRepository {
  Future<Either<Failure, String>> getLoginToken({
    bool lastYear,
  });
}
