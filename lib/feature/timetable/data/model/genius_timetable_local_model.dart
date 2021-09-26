import 'package:moor/moor.dart';

class GeniusTimetableLocalModel {
  String? dayOfWeek;
  int? subject;
  String? teacher;
  int? start;
  int? end;
  String? subjectName;

  GeniusTimetableLocalModel(
    this.dayOfWeek,
    this.teacher,
    this.subject,
    this.end,
    this.start,
    this.subjectName,
  );

  factory GeniusTimetableLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();

    return GeniusTimetableLocalModel(
      stringType.mapFromDatabaseResponse(data['${effectivePrefix}dayOfWeek']),
      stringType.mapFromDatabaseResponse(data['${effectivePrefix}teacher']),
      intType.mapFromDatabaseResponse(data['${effectivePrefix}subject']),
      intType.mapFromDatabaseResponse(data['${effectivePrefix}start']),
      intType.mapFromDatabaseResponse(data['${effectivePrefix}end']),
      stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_name']),
    );
  }

  @override
  String toString() {
    return '${this.dayOfWeek} - H${this.start} -> ${this.teacher}';
  }
}
