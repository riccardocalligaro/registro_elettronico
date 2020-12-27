import 'package:moor_flutter/moor_flutter.dart';

class Attachments extends Table {
  IntColumn get pubId => integer()();
  TextColumn get fileName => text()();
  IntColumn get attachNumber => integer()();

  @override
  Set<Column> get primaryKey => {pubId};
}
