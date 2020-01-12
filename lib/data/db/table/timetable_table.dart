import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('TimetableEntry')
class TimetableEntries extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn get start => integer()();
  IntColumn get end => integer()();
  IntColumn get dayOfWeek => integer()();
  IntColumn get subject => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
