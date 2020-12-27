import 'package:moor_flutter/moor_flutter.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get studentId => text()();
  TextColumn get ident => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get token => text()();
  DateTimeColumn get release => dateTime()();
  DateTimeColumn get expire => dateTime()();

  @override
  Set<Column> get primaryKey => {id, ident};
}
