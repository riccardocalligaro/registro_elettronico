import 'package:moor/moor.dart';

@DataClassName('ProfessorLocalModel')
class Professors extends Table {
  TextColumn get id => text()();
  IntColumn get subjectId => integer()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
