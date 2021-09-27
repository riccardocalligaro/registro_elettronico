import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/periods/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';

class GradesFailure extends StatelessWidget {
  final Failure? failure;

  const GradesFailure({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SRFailureView(
      failure: failure,
      refresh: () {
        final GradesRepository gradesRepository = sl();
        final PeriodsRepository periodsRepository = sl();
        final SubjectsRepository subjectsRepository = sl();

        return Future.wait([
          gradesRepository.updateGrades(ifNeeded: false),
          periodsRepository.updatePeriods(ifNeeded: false),
          subjectsRepository.updateSubjects(ifNeeded: false),
        ]);
      },
    );
  }
}
