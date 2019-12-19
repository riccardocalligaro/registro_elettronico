import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class AgendaRepository {
  ///Insert an event into the agenda
  Future insertEvent(AgendaEvent event);
  // updates the events in the agenda
  Future updateAllAgenda();

  Future updateAgendaStartingFromDate(DateTime begin);

  Future updateAgendaBetweenDates(DateTime begin, DateTime end);

  ///Gets all events
  Stream<List<AgendaEvent>> watchAllEvents();

  ///Gets last events of a date
  Stream<List<AgendaEvent>> watchLastEvents(DateTime date, int numbersOfEvents);

  ///Delete all events
  Future deleteAllEvents();
}
