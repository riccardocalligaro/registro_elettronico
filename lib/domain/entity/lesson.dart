import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  int evtId;
  String evtDate;
  String evtCode;
  int evtHPos;
  int evtDuration;
  String classDesc;
  String authorName;
  int subjectId;
  String subjectCode;
  String subjectDesc;
  String lessonType;
  String lessonArg;

  Lesson(
      {this.evtId,
      this.evtDate,
      this.evtCode,
      this.evtHPos,
      this.evtDuration,
      this.classDesc,
      this.authorName,
      this.subjectId,
      this.subjectCode,
      this.subjectDesc,
      this.lessonType,
      this.lessonArg});

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
