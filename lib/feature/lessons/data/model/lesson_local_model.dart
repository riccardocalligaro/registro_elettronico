import 'package:moor/moor.dart';

/// Resposnee from classeviva
/// {
///   "evtId": 4773759,
///   "evtDate": "2019-11-08",
///   "evtCode": "LSS0",
///   "evtHPos": 3,
///   "evtDuration": 1,
///   "classDesc": "4IA INFORMATICA",
///   "authorName": "GIULIANO ANDREINA",
///   "subjectId": 5,
///   "subjectCode": "SOST",
///   "subjectDesc": "SOSTEGNO",
///   "lessonType": "Compresenza",
///   "lessonArg": ""
/// }

class Lessons extends Table {
  IntColumn get eventId => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get code => text()();
  IntColumn get position => integer()();
  IntColumn get duration => integer()();
  TextColumn get classe => text()();
  TextColumn get author => text()();
  IntColumn get subjectId => integer()();
  TextColumn get subjectCode => text()();
  TextColumn get subjectDescription => text()();
  TextColumn get lessonType => text()();
  TextColumn get lessonArg => text()();

  @override
  Set<Column> get primaryKey => {eventId};
}
