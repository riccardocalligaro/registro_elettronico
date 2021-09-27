import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';

abstract class ScrutiniRepository {
  Future<Either<Failure, String>> getLoginToken({
    bool? lastYear,
  });
}
