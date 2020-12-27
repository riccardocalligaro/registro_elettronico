part of 'agenda_bloc.dart';

abstract class AgendaEvent {}

class UpdateAllAgenda extends AgendaEvent {}

class UpdateFromDate extends AgendaEvent {
  final DateTime date;

  UpdateFromDate({@required this.date});
}

class GetAllAgenda extends AgendaEvent {}

class GetNextEvents extends AgendaEvent {
  final DateTime dateTime;

  GetNextEvents({
    @required this.dateTime,
  });
}
