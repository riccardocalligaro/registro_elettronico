part of 'local_grades_bloc.dart';

@immutable
abstract class LocalGradesState {}

class LocalGradesInitial extends LocalGradesState {}

class LocalGradesLoading extends LocalGradesState {}

class LocalGradesLoaded extends LocalGradesState {
  final List<LocalGrade> localGrades;

  LocalGradesLoaded({
    @required this.localGrades,
  });
}

class LocalGradesError extends LocalGradesState {
  final String message;

  LocalGradesError(this.message);
}
