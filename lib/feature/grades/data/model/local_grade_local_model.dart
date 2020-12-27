import 'package:moor/moor.dart';

class LocalGrades extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subjectId => integer()();
  DateTimeColumn get eventDate => dateTime()();
  RealColumn get decimalValue => real()();
  TextColumn get displayValue => text()();
  BoolColumn get cancelled => boolean()();
  BoolColumn get underlined => boolean()();
  IntColumn get periodPos => integer()();
}
