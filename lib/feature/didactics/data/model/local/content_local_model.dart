import 'package:moor/moor.dart';

@DataClassName('ContentLocalModel')
class DidacticsContents extends Table {
  IntColumn? get folderId => integer()();
  IntColumn? get id => integer()();
  TextColumn? get name => text()();
  IntColumn? get objectId => integer()();
  TextColumn? get type => text()();
  DateTimeColumn? get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id!};
}
