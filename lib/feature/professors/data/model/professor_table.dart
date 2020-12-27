import 'package:moor/moor.dart';

// "teacherId": "A3175375",
// "teacherName": "CAZZIOLATO ALESSANDRO"

class Professors extends Table {
  TextColumn get id => text()();
  IntColumn get subjectId => integer()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
