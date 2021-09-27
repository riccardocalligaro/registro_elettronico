import 'dart:convert';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class LessonDomainModel {
  int? id;
  DateTime? date;
  String? code;
  int? position;
  int? duration;
  String? classDescription;
  String? author;
  int? subjectId;
  String? subjectCode;
  String? subjectDescription;
  String? lessonType;
  String? lessonArgoment;

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

  LessonDomainModel copyWith({
    int? id,
    DateTime? date,
    String? code,
    int? position,
    int? duration,
    String? classDescription,
    String? author,
    int? subjectId,
    String? subjectCode,
    String? subjectDescription,
    String? lessonType,
    String? lessonArgoment,
  }) {
    return LessonDomainModel(
      id: id ?? this.id,
      date: date ?? this.date,
      code: code ?? this.code,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      classDescription: classDescription ?? this.classDescription,
      author: author ?? this.author,
      subjectId: subjectId ?? this.subjectId,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectDescription: subjectDescription ?? this.subjectDescription,
      lessonType: lessonType ?? this.lessonType,
      lessonArgoment: lessonArgoment ?? this.lessonArgoment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date?.millisecondsSinceEpoch,
      'code': code,
      'position': position,
      'duration': duration,
      'classDescription': classDescription,
      'author': author,
      'subjectId': subjectId,
      'subjectCode': subjectCode,
      'subjectDescription': subjectDescription,
      'lessonType': lessonType,
      'lessonArgoment': lessonArgoment,
    };
  }

  static LessonDomainModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return LessonDomainModel(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      code: map['code'],
      position: map['position'],
      duration: map['duration'],
      classDescription: map['classDescription'],
      author: map['author'],
      subjectId: map['subjectId'],
      subjectCode: map['subjectCode'],
      subjectDescription: map['subjectDescription'],
      lessonType: map['lessonType'],
      lessonArgoment: map['lessonArgoment'],
    );
  }

  String toJson() => json.encode(toMap());

  static LessonDomainModel? fromJson(String source) =>
      LessonDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LessonDomainModel(id: $id, date: $date, code: $code, position: $position, duration: $duration, classDescription: $classDescription, author: $author, subjectId: $subjectId, subjectCode: $subjectCode, subjectDescription: $subjectDescription, lessonType: $lessonType, lessonArgoment: $lessonArgoment)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LessonDomainModel &&
        o.id == id &&
        o.date == date &&
        o.code == code &&
        o.position == position &&
        o.duration == duration &&
        o.classDescription == classDescription &&
        o.author == author &&
        o.subjectId == subjectId &&
        o.subjectCode == subjectCode &&
        o.subjectDescription == subjectDescription &&
        o.lessonType == lessonType &&
        o.lessonArgoment == lessonArgoment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        code.hashCode ^
        position.hashCode ^
        duration.hashCode ^
        classDescription.hashCode ^
        author.hashCode ^
        subjectId.hashCode ^
        subjectCode.hashCode ^
        subjectDescription.hashCode ^
        lessonType.hashCode ^
        lessonArgoment.hashCode;
  }
}
