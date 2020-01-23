import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class AbsencesState extends Equatable {
  const AbsencesState();

  @override
  List<Object> get props => [];
}

class AbsencesInitial extends AbsencesState {}

class AbsencesUpdateLoading extends AbsencesState {}

class AbsencesUpdateLoaded extends AbsencesState {}

class AbsencesUpdateError extends AbsencesState {
  final String message;

  AbsencesUpdateError(this.message);
}

class AbsencesLoading extends AbsencesState {}

class AbsencesLoadErrorNotConnected extends AbsencesState {}

class AbsencesLoaded extends AbsencesState {
  final List<Absence> absences;

  const AbsencesLoaded({
    @required this.absences,
  });
}

class AbsencesError extends AbsencesState {
  final String message;

  AbsencesError(this.message);
}
