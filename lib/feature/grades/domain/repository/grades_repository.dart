import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';

abstract class GradesRepository {
  Stream<Resource<List<GradeDomainModel>>> watchAllGrades();

  Stream<Resource<GradesPagesDomainModel>> watchAllGradesSections();

  Future<Either<Failure, Success>> updateGrades({@required bool ifNeeded});

  Future<Either<Failure, GradeDomainModel>> getGrade(String id);

  Future<Either<Failure, List<GradeDomainModel>>> getGrades();
}
