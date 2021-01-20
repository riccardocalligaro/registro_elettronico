import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_event_remote_model.dart';

@DataClassName('AgendaEventLocalModel')
class AgendaEventsTable extends Table {
  IntColumn get evtId => integer()();
  TextColumn get evtCode => text()();
  DateTimeColumn get begin => dateTime()();
  DateTimeColumn get end => dateTime()();
  BoolColumn get isFullDay => boolean()();
  TextColumn get notes => text()();
  TextColumn get authorName => text()();
  TextColumn get classDesc => text()();
  IntColumn get subjectId => integer()();
  TextColumn get subjectDesc => text()();
  BoolColumn get isLocal => boolean()();
  TextColumn get labelColor => text()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {evtId};

  @override
  String get tableName => 'agenda_events';
}

class AgendaEventLocalModelConverter {
  static AgendaEventLocalModel fromRemoteModel(
    AgendaEventRemoteModel r,
    AgendaEventLocalModel l,
  ) {
    return AgendaEventLocalModel(
      evtId: r.evtId,
      evtCode: r.evtCode,
      begin: DateTime.parse(r.evtDatetimeBegin) ?? DateTime.now(),
      end: DateTime.parse(r.evtDatetimeEnd) ?? DateTime.now(),
      isFullDay: r.isFullDay,
      notes: r.notes,
      authorName: r.authorName,
      classDesc: r.classDesc,
      subjectId: r.subjectId,
      subjectDesc: r.subjectDesc,
      isLocal: l.isLocal,
      labelColor: l.labelColor,
      title: l.title,
    );
  }
}
