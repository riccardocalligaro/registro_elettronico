import 'package:moor/moor.dart';

@DataClassName('TeacherLocalModel')
class DidacticsTeachers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();

  @override
  Set<Column> get primaryKey => {id};
}
