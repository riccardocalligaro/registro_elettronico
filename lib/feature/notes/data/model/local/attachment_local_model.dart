import 'package:moor/moor.dart';

class Attachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pubId => integer()();
  TextColumn get fileName => text()();
  IntColumn get attachNumber => integer()();
}
