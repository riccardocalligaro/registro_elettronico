import 'package:equatable/equatable.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class GradesState extends Equatable {
  const GradesState();

  @override
  List<Object> get props => [];
}

class GradesInitial extends GradesState {}

class GradesUpdateLoading extends GradesState {}

class GradesUpdateLoaded extends GradesState {}

class GradesUpdateError extends GradesState {
  final String message;

  GradesUpdateError(this.message);
}

// Only grades

class GradesLoading extends GradesState {}

class GradesLoaded extends GradesState {
  final List<Grade> grades;

  GradesLoaded(this.grades);
}

class GradesError extends GradesState {
  final String message;

  GradesError(this.message);
}

// Grades and subjects

class GradesAndSubjectsLoading extends GradesState {}

class GradesAndSubjectsLoaded extends GradesState {
  final Map<dynamic, List<Grade>> data;

  GradesAndSubjectsLoaded(this.data);
}

class GradesAndSubjectsError extends GradesState {
  final String message;

  GradesAndSubjectsError(this.message);
}
