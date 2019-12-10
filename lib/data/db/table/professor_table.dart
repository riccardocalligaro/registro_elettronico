import 'package:moor_flutter/moor_flutter.dart';

// "teacherId": "A3175375",
// "teacherName": "CAZZIOLATO ALESSANDRO"

class Professors extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
}
