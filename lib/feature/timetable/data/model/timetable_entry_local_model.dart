import 'package:moor/moor.dart';

@DataClassName('TimetableEntryLocalModel')
class TimetableEntries extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn get start => integer()();
  IntColumn get end => integer()();
  IntColumn get dayOfWeek => integer()();
  IntColumn get subject => integer()();
  TextColumn get subjectName => text()();
}
