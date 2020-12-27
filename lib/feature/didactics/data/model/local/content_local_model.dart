import 'package:moor/moor.dart';

/// "contentId": 14842217,
/// "contentName": "",
/// "objectId": 8562350,
/// "objectType": "file",
/// "shareDT": "2019-10-21T11:55:34+02:00"
class DidacticsContents extends Table {
  IntColumn get folderId => integer()();
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get objectId => integer()();
  TextColumn get type => text()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
