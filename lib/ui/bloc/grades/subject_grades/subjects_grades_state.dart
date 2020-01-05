import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class SubjectsGradesState {}

class SubjectsGradesInitial extends SubjectsGradesState {}

class SubjectsGradesLoadInProgress extends SubjectsGradesState {}

class SubjectsGradesLoadSuccess extends SubjectsGradesState {
  final List<Subject> subjects;
  final List<Grade> grades;

  SubjectsGradesLoadSuccess({
    @required this.subjects,
    @required this.grades,
  });
}

class SubjectsGradesLoadError extends SubjectsGradesState {
  final String error;
  
  SubjectsGradesLoadError({@required this.error});
}
