part of 'agenda_updater_bloc.dart';

@immutable
abstract class AgendaUpdaterState {}

class AgendaUpdaterInitial extends AgendaUpdaterState {}

class AgendaUpdaterLoading extends AgendaUpdaterState {}

class AgendaUpdaterSuccess extends AgendaUpdaterState {
  final Success success;

  AgendaUpdaterSuccess({required this.success});
}

class AgendaUpdaterFailure extends AgendaUpdaterState {
  final Failure failure;

  AgendaUpdaterFailure({required this.failure});
}
