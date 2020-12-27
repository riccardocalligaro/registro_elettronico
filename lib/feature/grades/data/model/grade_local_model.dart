import 'package:moor/moor.dart';

class Grades extends Table {
  IntColumn get subjectId => integer()();
  TextColumn get subjectDesc => text()();
  IntColumn get evtId => integer()();
  TextColumn get evtCode => text()();
  DateTimeColumn get eventDate => dateTime()();
  RealColumn get decimalValue => real()();
  TextColumn get displayValue => text()();
  IntColumn get displayPos => integer()();
  TextColumn get notesForFamily => text()();
  BoolColumn get cancelled => boolean()();
  BoolColumn get underlined => boolean()();
  IntColumn get periodPos => integer()();
  TextColumn get periodDesc => text()();
  IntColumn get componentPos => integer()();
  TextColumn get componentDesc => text()();
  IntColumn get weightFactor => integer()();
  IntColumn get skillId => integer()();
  IntColumn get gradeMasterId => integer()();
  BoolColumn get localllyCancelled => boolean()();

  @override
  Set<Column> get primaryKey => {evtId};
}
