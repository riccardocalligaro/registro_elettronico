import 'package:moor/moor.dart';

@DataClassName('SubjectLocalModel')
class Subjects extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get orderNumber => integer()();
  TextColumn get color => text()();

  @override
  Set<Column> get primaryKey => {id};
}
