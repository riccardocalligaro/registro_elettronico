import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_local_model.dart';

part 'agenda_dao.g.dart';

@UseDao(tables: [AgendaEvents])
class AgendaDao extends DatabaseAccessor<AppDatabase> with _$AgendaDaoMixin {
  AppDatabase db;

  AgendaDao(this.db) : super(db);

  Future insertEvent(AgendaEvent event) =>
      into(agendaEvents).insertOnConflictUpdate(event);

  Future<void> insertEvents(List<AgendaEvent> events) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(agendaEvents, events);
    });
  }

  Future<List<AgendaEvent>> getAllEvents() => select(agendaEvents).get();

  Future<List<AgendaEvent>> getLastEvents(
    DateTime date, {
    int numbersOfEvents,
  }) {
    if (numbersOfEvents != null) {
      return (select(agendaEvents)
            ..where((event) => event.end.isBiggerOrEqualValue(date))
            ..limit(numbersOfEvents))
          .get();
    } else {
      return (select(agendaEvents)
            ..where((event) => event.end.isBiggerOrEqualValue(date)))
          .get();
    }
  }

  Future deleteAllEvents() => delete(agendaEvents).go();

  Future deleteAllEventsWithoutLocal() {
    return (delete(agendaEvents)..where((a) => a.isLocal.equals(false))).go();
  }

  Future deleteEventsFromDate(DateTime date) {
    return (delete(agendaEvents)
          ..where((a) =>
              a.begin.isSmallerOrEqualValue(date) & a.isLocal.equals(false)))
        .go();
  }

  Future deleteEvent(AgendaEvent event) => delete(agendaEvents).delete(event);

  Future updateEvent(AgendaEvent event) => update(agendaEvents).replace(event);
}
