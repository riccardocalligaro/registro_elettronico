import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class GradesState {
  const GradesState();
}

class GradesInitial extends GradesState {}

class GradesUpdateLoading extends GradesState {}

class GradesUpdateLoaded extends GradesState {}

class GradesUpdateError extends GradesState {
  final String message;

  GradesUpdateError({
    @required this.message,
  });
}

// Only grades

class GradesLoading extends GradesState {}

class GradesLoaded extends GradesState {
  final List<Grade> grades;

  GradesLoaded(this.grades);
}

class GradesError extends GradesState {
  final String message;

  GradesError({
    @required this.message,
  });
}
