import 'package:moor/moor.dart';

/// "folderId": 14842214,
/// "folderName": "Primo Soccorso",
/// "lastShareDT": "2019-10-21T11:55:34+02:00",
class DidacticsFolders extends Table {
  TextColumn get teacherId => text()();
  IntColumn get id => integer()();
  TextColumn get name => text()();
  DateTimeColumn get lastShare => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
