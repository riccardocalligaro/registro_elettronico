import 'package:moor_flutter/moor_flutter.dart';

class GeniusTimetable {
  String dayOfWeek;
  int subject;
  String teacher;
  int start;
  int end;

  GeniusTimetable(
    this.dayOfWeek,
    this.teacher,
    this.subject,
    this.end,
    this.start,
  );

  factory GeniusTimetable.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();

    return GeniusTimetable(
      stringType.mapFromDatabaseResponse(data['${effectivePrefix}dayOfWeek']),
      stringType.mapFromDatabaseResponse(data['${effectivePrefix}teacher']),
      intType.mapFromDatabaseResponse(data['${effectivePrefix}subject']),
      intType.mapFromDatabaseResponse(data['${effectivePrefix}start']),
      intType.mapFromDatabaseResponse(data['${effectivePrefix}end']),
    );
  }

  @override
  String toString() {
    return '${this.dayOfWeek} - H${this.start} -> ${this.teacher}';
  }
}
