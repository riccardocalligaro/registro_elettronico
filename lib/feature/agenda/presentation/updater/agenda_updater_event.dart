part of 'agenda_updater_bloc.dart';

@immutable
abstract class AgendaUpdaterEvent {}

class UpdateAgendaIfNeeded extends AgendaUpdaterEvent {
  final bool onlyLastDays;

  UpdateAgendaIfNeeded({
    @required this.onlyLastDays,
  });
}

class UpdateAgenda extends AgendaUpdaterEvent {
  final bool onlyLastDays;

  UpdateAgenda({
    @required this.onlyLastDays,
  });
}
