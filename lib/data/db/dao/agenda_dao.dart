import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/agenda_event_table.dart';

part 'agenda_dao.g.dart';

@UseDao(tables: [AgendaEvents])
class AgendaDao extends DatabaseAccessor<AppDatabase> with _$AgendaDaoMixin {
  AppDatabase db;
  AgendaDao(this.db) : super(db);

  Future insertEvent(AgendaEvent event) =>
      into(agendaEvents).insert(event, orReplace: true);

  Future insertEvents(List<AgendaEvent> events) =>
      into(agendaEvents).insertAll(events, orReplace: true);

  Future<List<AgendaEvent>> getAllEvents() => select(agendaEvents).get();

  Future<List<AgendaEvent>> getLastEvents(DateTime date, int numbersOfEvents) {
    return (select(agendaEvents)
          ..where((event) => event.end.isBiggerOrEqualValue(date))
          ..limit(numbersOfEvents))
        .get();
  }

  Future deleteAllEvents() => delete(agendaEvents).go();
}
