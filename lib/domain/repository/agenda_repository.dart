abstract class AgendaRepository {
  // updates the events in the agenda
  Future updateAllAgenda();

  Future updateAgendaStartingFromDate(DateTime begin);

  Future updateAgendaBetweenDates(DateTime begin, DateTime end);
}
