import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/agenda_response.dart';

/// IntColumn get evtId => integer()();
/// TextColumn get evtCode => text()();
/// DateTimeColumn get begin => dateTime()();
/// DateTimeColumn get end => dateTime()();
/// BoolColumn get isFullDay => boolean()();
/// TextColumn get notes => text()();
/// TextColumn get authorName => text()();
/// TextColumn get classDesc => text()();
/// IntColumn get subjectId => integer()();
/// TextColumn get subjectDesc => text()();

class EventMapper {
  const EventMapper();

  db.AgendaEvent convertEventEntityToInsertable(Event event) {
    return db.AgendaEvent(
        evtId: event.evtId,
        evtCode: event.evtCode,
        begin: DateTime.parse(event.evtDatetimeBegin),
        end: DateTime.parse(event.evtDatetimeEnd),
        isFullDay: event.isFullDay,
        notes: event.notes,
        authorName: event.authorName,
        classDesc: event.classDesc,
        subjectId: event.subjectId ?? 0,
        subjectDesc: event.subjectDesc ?? "");
  }
}
