import 'package:moor/moor.dart';

class DidacticsDownloadedFiles extends Table {
  TextColumn get name => text()();
  TextColumn get path => text()();
  IntColumn get contentId => integer()();

  @override
  Set<Column> get primaryKey => {contentId};
}
