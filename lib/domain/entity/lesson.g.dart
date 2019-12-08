// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return Lesson(
    evtId: json['evtId'] as int,
    evtDate: json['evtDate'] as String,
    evtCode: json['evtCode'] as String,
    evtHPos: json['evtHPos'] as int,
    evtDuration: json['evtDuration'] as int,
    classDesc: json['classDesc'] as String,
    authorName: json['authorName'] as String,
    subjectId: json['subjectId'] as int,
    subjectCode: json['subjectCode'] as String,
    subjectDesc: json['subjectDesc'] as String,
    lessonType: json['lessonType'] as String,
    lessonArg: json['lessonArg'] as String,
  );
}

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'evtId': instance.evtId,
      'evtDate': instance.evtDate,
      'evtCode': instance.evtCode,
      'evtHPos': instance.evtHPos,
      'evtDuration': instance.evtDuration,
      'classDesc': instance.classDesc,
      'authorName': instance.authorName,
      'subjectId': instance.subjectId,
      'subjectCode': instance.subjectCode,
      'subjectDesc': instance.subjectDesc,
      'lessonType': instance.lessonType,
      'lessonArg': instance.lessonArg,
    };
