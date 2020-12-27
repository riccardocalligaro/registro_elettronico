import 'package:moor_flutter/moor_flutter.dart';

//   IntColumn get eventId => integer()();
/// "id": 215867,
///    "description": "INFORMATICA",
///    "order": 8,
///    "teachers": [
///        {
///            "teacherId": "A3175375",
///            "teacherName": "CAZZIOLATO ALESSANDRO"
///        },
///        {
///            "teacherId": "A3270031",
///            "teacherName": "RONCHI GIANCARLO"
///        }
///    ]
///},
class Subjects extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get orderNumber => integer()();
  TextColumn get color => text()();

  @override
  Set<Column> get primaryKey => {id};
}
