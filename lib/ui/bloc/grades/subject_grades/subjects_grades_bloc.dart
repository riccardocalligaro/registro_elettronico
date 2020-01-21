import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/entity/subject_objective.dart';
import 'package:registro_elettronico/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/domain/repository/repositories_export.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

class SubjectsGradesBloc
    extends Bloc<SubjectsGradesEvent, SubjectsGradesState> {
  SubjectsRepository subjectsRepository;
  GradesRepository gradesRepository;
  PeriodsRepository periodsRepository;

  SubjectsGradesBloc(
    this.subjectsRepository,
    this.gradesRepository,
    this.periodsRepository,
  );

  @override
  SubjectsGradesState get initialState => SubjectsGradesInitial();

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

      final prefs = await SharedPreferences.getInstance();
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
      Crashlytics.instance.recordError(e, s);
      yield SubjectsGradesLoadError(error: e.toString());
    }
  }

  Stream<SubjectsGradesState> _mapUpdateSubjectGradesToState() async* {
    yield SubjectsGradesUpdateLoadInProgress();
    try {
      await gradesRepository.updateGrades();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(
        PrefsConstants.LAST_UPDATE_GRADES,
        DateTime.now().millisecondsSinceEpoch,
      );
      yield SubjectsGradesUpdateLoadSuccess();
    } on NotConntectedException catch (_) {
      yield SubjectsGradesLoadNotConnected();
    } catch (e, s) {
      Crashlytics.instance.recordError(e, s);
      yield SubjectsGradesLoadError(error: e.toString());
    }
  }
}
