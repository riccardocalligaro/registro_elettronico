import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('TimetableEntry')
class TimetableEntries extends Table {
  IntColumn get eventId => integer()();
  DateTimeColumn get date => dateTime()();
  IntColumn get position => integer()();
  IntColumn get duration => integer()();
  TextColumn get subject => text()();
  TextColumn get author => text()();
  @override
  Set<Column> get primaryKey => {eventId};
}
