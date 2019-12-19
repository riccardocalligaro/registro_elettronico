import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class PeriodsState extends Equatable {
  const PeriodsState();

  @override
  List<Object> get props => [];
}

class PeriodsInitial extends PeriodsState {}

// For updated
class PeriodsUpdateLoading extends PeriodsState {}

class PeriodsUpdateLoaded extends PeriodsState {}

class PeriodsUpdateError extends PeriodsState {
  final String message;

  PeriodsUpdateError(this.message);
}

// For getting periods
class PeriodsLoading extends PeriodsState {}

class PeriodsLoaded extends PeriodsState {
  final List<Period> periods;

  PeriodsLoaded({@required this.periods});
}

class PeriodsError extends PeriodsState {
  final String message;

  PeriodsError(this.message);
}
