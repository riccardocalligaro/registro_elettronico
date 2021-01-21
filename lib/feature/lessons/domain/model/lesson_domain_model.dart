import 'package:registro_elettronico/core/data/local/moor_database.dart';

class LessonDomainModel {
  int id;
  DateTime date;
  String code;
  int position;
  int duration;
  String classDescription;
  String author;
  int subjectId;
  String subjectCode;
  String subjectDescription;
  String lessonType;
  String lessonArgoment;

  LessonDomainModel({
    this.id,
    this.date,
    this.code,
    this.position,
    this.duration,
    this.classDescription,
    this.author,
    this.subjectId,
    this.subjectCode,
    this.subjectDescription,
    this.lessonType,
    this.lessonArgoment,
  });

  LessonDomainModel.fromLocalModel(LessonLocalModel l) {
    this.id = l.eventId;
    this.date = l.date;
    this.code = l.code;
    this.position = l.position;
    this.duration = l.duration;
    this.classDescription = l.classe;
    this.author = l.author;
    this.subjectId = l.subjectId;
    this.subjectCode = l.subjectCode;
    this.subjectDescription = l.subjectDescription;
    this.lessonType = l.lessonType;
    this.lessonArgoment = l.lessonArg;
  }
}
