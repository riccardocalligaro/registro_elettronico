import 'package:moor_flutter/moor_flutter.dart';

/// "pubId": 4911199,
/// "pubDT": "2019-12-16T09:54:59+01:00",
/// "readStatus": false,
/// "evtCode": "CF",
/// "cntId": 2788481,
/// "cntValidFrom": "2019-12-16",
/// "cntValidTo": "2020-05-31",
/// "cntValidInRange": true,
/// "cntStatus": "active",
/// "cntTitle": "CIRC - 185 ESAME FINALE CORSO LINUX ESSENTIALS e compilazione scheda di gradimento  del 20 dicembre 2019",
/// "cntCategory": "Circolare",
/// "cntHasChanged": false,
/// "cntHasAttach": true,
/// "needJoin": false,
/// "needReply": false,
/// "needFile": false,
/// "evento_id": "2788481",

class Notices extends Table {
  IntColumn get pubId => integer()();
  DateTimeColumn get pubDate => dateTime()();
  BoolColumn get readStatus => boolean()();
  TextColumn get eventCode => text()();
  IntColumn get contentId => integer()();
  DateTimeColumn get contentValidFrom => dateTime()();
  DateTimeColumn get contentValidTo => dateTime()();
  BoolColumn get contentValidInRange => boolean()();
  TextColumn get contentStatus => text()();
  TextColumn get contentTitle => text()();
  TextColumn get contentCategory => text()();
  BoolColumn get contentHasChanged => boolean()();
  BoolColumn get contentHasAttach => boolean()();
  BoolColumn get needJoin => boolean()();
  BoolColumn get needReply => boolean()();
  BoolColumn get needFile => boolean()();
  TextColumn get eventId => text()();

  @override
  Set<Column> get primaryKey => {pubId};
}
