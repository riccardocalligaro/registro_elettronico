part of 'periods_bloc.dart';

@immutable
abstract class PeriodsState {}

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
