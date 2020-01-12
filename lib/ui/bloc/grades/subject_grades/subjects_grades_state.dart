import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/subject_objective.dart';

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

class SubjectsGradesLoadError extends SubjectsGradesState {
  final String error;

  SubjectsGradesLoadError({@required this.error});
}
