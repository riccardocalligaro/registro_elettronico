import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/error/failures.dart';

abstract class ScrutiniRepository {
  Future<Either<Failure, String>> getLoginToken();
}
