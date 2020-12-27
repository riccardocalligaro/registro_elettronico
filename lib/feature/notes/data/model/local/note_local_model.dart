import 'package:moor_flutter/moor_flutter.dart';

class Notes extends Table {
  TextColumn get author => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get id => integer()();
  BoolColumn get status => boolean()();
  TextColumn get description => text()();
  TextColumn get warning => text()();
  TextColumn get type => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class NotesAttachments extends Table {
  IntColumn get id => integer()();
  TextColumn get type => text()();
  TextColumn get description => text()();

  @override
  Set<Column> get primaryKey => {id};
}
