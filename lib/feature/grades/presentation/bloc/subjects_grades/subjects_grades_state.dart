part of 'subjects_grades_bloc.dart';

@immutable
abstract class SubjectsGradesState {}

class SubjectsGradesInitial extends SubjectsGradesState {}

class SubjectsGradesUpdateLoadInProgress extends SubjectsGradesState {}

class SubjectsGradesUpdateLoadSuccess extends SubjectsGradesState {}

class SubjectsGradesLoadInProgress extends SubjectsGradesState {}

class SubjectsGradesLoadSuccess extends SubjectsGradesState {
  final List<Subject> subjects;
  final List<Grade> grades;
  final List<Period> periods;
  final List<SubjectObjective> objectives;
  final int generalObjective;

  SubjectsGradesLoadSuccess({
    @required this.subjects,
    @required this.grades,
    @required this.periods,
    @required this.objectives,
    @required this.generalObjective,
  });
}

class SubjectsGradesLoadNotConnected extends SubjectsGradesState {}

class SubjectsGradesLoadError extends SubjectsGradesState {
  final String error;

  SubjectsGradesLoadError({@required this.error});
}
