import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/subject_objective.dart';
import 'package:registro_elettronico/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'subjects_grades_event.dart';

part 'subjects_grades_state.dart';

class SubjectsGradesBloc
    extends Bloc<SubjectsGradesEvent, SubjectsGradesState> {

  final GradesRepository gradesRepository;
  final SubjectsRepository subjectsRepository;
  final PeriodsRepository periodsRepository;

  SubjectsGradesBloc({
    @required this.gradesRepository,
    @required this.subjectsRepository,
    @required this.periodsRepository,
  }) : super(SubjectsGradesInitial());

  @override
  Stream<SubjectsGradesState> mapEventToState(
    SubjectsGradesEvent event,
  ) async* {
    if (event is GetGradesAndSubjects) {
      yield* _mapGetGradesAndSubjectsToState();
    } else if (event is UpdateSubjectGrades) {
      yield* _mapUpdateSubjectGradesToState();
    }
  }

  Stream<SubjectsGradesState> _mapGetGradesAndSubjectsToState() async* {
    //yield SubjectsGradesLoadInProgress();
    try {
      final subjects = await subjectsRepository.getAllSubjects();
      final grades = await gradesRepository.getAllGrades();
      final periods = await periodsRepository.getAllPeriods();

      SharedPreferences prefs = sl();
      final generalObjective =
          prefs.getInt(PrefsConstants.OVERALL_OBJECTIVE) ?? 6;

      List<SubjectObjective> objectives = [];
      subjects.forEach((subject) {
        final obj = prefs.getInt('${subject.id}_objective');
        if (obj != null) {
          objectives
              .add(SubjectObjective(subjectId: subject.id, objective: obj));
        } else {
          objectives.add(SubjectObjective(
              subjectId: subject.id, objective: generalObjective));
        }
      });

      yield SubjectsGradesLoadSuccess(
        subjects: subjects,
        grades: grades,
        periods: periods,
        objectives: objectives,
        generalObjective: generalObjective,
      );
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield SubjectsGradesLoadError(error: e.toString());
    }
  }

  Stream<SubjectsGradesState> _mapUpdateSubjectGradesToState() async* {
    yield SubjectsGradesUpdateLoadInProgress();
    try {
      await gradesRepository.updateGrades();
      SharedPreferences prefs = sl();

      await prefs.setInt(
        PrefsConstants.LAST_UPDATE_GRADES,
        DateTime.now().millisecondsSinceEpoch,
      );

      yield SubjectsGradesUpdateLoadSuccess();
    } on NotConntectedException catch (_) {
      yield SubjectsGradesLoadNotConnected();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield SubjectsGradesLoadError(error: e.toString());
    }
  }
}
