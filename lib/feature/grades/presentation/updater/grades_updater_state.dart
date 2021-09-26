part of 'grades_updater_bloc.dart';

@immutable
abstract class GradesUpdaterState {}

class GradesUpdaterInitial extends GradesUpdaterState {}

class GradesUpdaterLoading extends GradesUpdaterState {}

class GradesUpdaterSuccess extends GradesUpdaterState {
  final Success success;

  GradesUpdaterSuccess({required this.success});
}

class GradesUpdaterFailure extends GradesUpdaterState {
  final Failure failure;

  GradesUpdaterFailure({required this.failure});
}
