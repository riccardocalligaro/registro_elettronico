part of 'agenda_dashboard_bloc.dart';

@immutable
abstract class AgendaDashboardState {}

class AgendaDashboardInitial extends AgendaDashboardState {}


class AgendaDashboardLoadInProgress extends AgendaDashboardState {}

class AgendaDashboardLoadSuccess extends AgendaDashboardState {
  final List<AgendaEvent> events;

  AgendaDashboardLoadSuccess({@required this.events});
}

class AgendaDashboardLoadError extends AgendaDashboardState {}

