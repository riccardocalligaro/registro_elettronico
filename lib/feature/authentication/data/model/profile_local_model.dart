import 'package:moor/moor.dart';

@DataClassName('ProfileLocalModel')
class Profiles extends Table {
  TextColumn get studentId => text()();
  TextColumn get ident => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get token => text()();
  DateTimeColumn get release => dateTime()();
  DateTimeColumn get expire => dateTime()();
  BoolColumn get currentlyLoggedIn => boolean()();

  @override
  Set<Column> get primaryKey => {ident};
}
