import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:moor/moor.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_event_local_model.dart';

part 'agenda_local_datasource.g.dart';

@UseDao(tables: [AgendaEventsTable])
class AgendaLocalDatasource extends DatabaseAccessor<SRDatabase>
    with _$AgendaLocalDatasourceMixin {
  SRDatabase db;

  AgendaLocalDatasource(this.db) : super(db);

  Stream<List<AgendaEventLocalModel>> watchAllEvents() =>
      select(agendaEventsTable).watch();

  Future<List<AgendaEventLocalModel>> getAllEvents() =>
      select(agendaEventsTable).get();

  Future<void> insertEvents(List<AgendaEventLocalModel> events) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(agendaEventsTable, events);
    });
  }

  Future<void> insertEvent(AgendaEventLocalModel event) =>
      into(agendaEventsTable).insertOnConflictUpdate(event);

  Future<void> deleteEvent(AgendaEventLocalModel event) =>
      delete(agendaEventsTable).delete(event);

  Future<void> deleteAllEvents() => delete(agendaEventsTable).go();

  Future deleteEventWithId(int? id) {
    return (delete(agendaEventsTable)..where((t) => t.evtId.equals(id))).go();
  }

  Future<void> updateEvent(AgendaEventLocalModel event) =>
      update(agendaEventsTable).replace(event);

  Future<void> deleteEvents(List<AgendaEventLocalModel> eventsToDelete) async {
    await batch((batch) {
      eventsToDelete.forEach((entry) {
        batch.delete(agendaEventsTable, entry);
      });
    });
  }
}
