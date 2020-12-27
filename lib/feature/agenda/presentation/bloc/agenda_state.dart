part of 'agenda_bloc.dart';

@immutable
abstract class AgendaState {}

class AgendaInitial extends AgendaState {}

// Updates
class AgendaUpdateLoadInProgress extends AgendaState {}

class AgendaUpdateLoadSuccess extends AgendaState {}

// Updates
class AgendaLoadInProgress extends AgendaState {}

class AgendaLoadSuccess extends AgendaState {
  final Map<DateTime, List<db.AgendaEvent>> eventsMap;
  final List<db.AgendaEvent> events;

  AgendaLoadSuccess({@required this.events, @required this.eventsMap});
}

class AgendaLoadErrorNotConnected extends AgendaState {}

class AgendaLoadError extends AgendaState {
  final String error;

  AgendaLoadError({@required this.error});
}
