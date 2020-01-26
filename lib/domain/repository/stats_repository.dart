import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/entity/student_report.dart';

abstract class StatsRepository {
  Future<Either<Failure, StudentReport>> getStudentReport();
}
