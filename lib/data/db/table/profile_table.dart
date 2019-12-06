import 'package:moor_flutter/moor_flutter.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().customConstraint('UNIQUE')();
  TextColumn get name => text()();
  TextColumn get classe => text()();
  TextColumn get token => text()();
  DateTimeColumn get expire => dateTime()();
  TextColumn get ident => text()();

  @override
  Set<Column> get primaryKey => {id, userName};
}
