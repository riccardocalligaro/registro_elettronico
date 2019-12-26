import 'package:moor_flutter/moor_flutter.dart';

/// "teacherId": "A3175368",
/// "teacherName": "BORSATO DONATA",
/// "teacherFirstName": "DONATA",
/// "teacherLastName": "BORSATO",
class DidacticsTeachers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();

  @override
  Set<Column> get primaryKey => {id};
}
