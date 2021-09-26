import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/last_lessons_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';

abstract class LessonsRepository {
  Stream<Resource<List<LessonDomainModel>>> watchLessonsForSubjectId({
    required int? subjectId,
  });

  Stream<Resource<List<LessonDomainModel>>> watchAllLessons();

  Stream<Resource<List<LessonWithDurationDomainModel>>>
      watchLatestLessonsWithDuration();

  Future<Either<Failure, Success>> updateAllLessons({
    required bool ifNeeded,
  });

  Future<Either<Failure, Success>> updateTodaysLessons({
    required bool ifNeeded,
  });
}
