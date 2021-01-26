import 'package:moor/moor.dart';

@DataClassName('FolderLocalModel')
class DidacticsFolders extends Table {
  TextColumn get teacherId => text()();
  IntColumn get id => integer()();
  TextColumn get name => text()();
  DateTimeColumn get lastShare => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
