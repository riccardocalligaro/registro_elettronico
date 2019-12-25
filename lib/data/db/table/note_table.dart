import 'package:moor_flutter/moor_flutter.dart';

class Notes extends Table {
  TextColumn get author => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get id => integer()();
  BoolColumn get status => boolean()();
  TextColumn get description => text()();
  TextColumn get warning => text()();
  TextColumn get type => text()();
}
