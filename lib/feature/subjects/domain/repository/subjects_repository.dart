import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';

abstract class SubjectsRepository {
  Future<Either<Failure, bool>> needToUpdateSubjects();

  Stream<Resource<List<SubjectDomainModel>>> watchAllSubjects();

  Future<Either<Failure, Success>> updateSubjects({
    required bool ifNeeded,
  });
}
