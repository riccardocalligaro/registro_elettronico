import 'package:moor_flutter/moor_flutter.dart';

// "evtId": 307339,
// "evtCode": "AGNT",
// "evtDatetimeBegin": "2019-11-23T11:00:00+01:00",
// "evtDatetimeEnd": "2019-11-23T12:00:00+01:00",
// "isFullDay": false,
// "notes": "Verifica scritta",
// "authorName": "BULZATTI ALBERTO",
// "classDesc": "4IA INFORMATICA",
// "subjectId": null,
// "subjectDesc": null
class AgendaEvents extends Table {
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
}
