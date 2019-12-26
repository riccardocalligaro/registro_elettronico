import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class LocalGradesState extends Equatable {
  const LocalGradesState();

  @override
  List<Object> get props => [];
}

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
