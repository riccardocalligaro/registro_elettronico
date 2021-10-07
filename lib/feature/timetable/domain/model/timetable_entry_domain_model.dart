import 'dart:convert';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class TimetableEntryDomainModel {
  int? id;
  int? start;
  int? end;
  int? dayOfWeek;
  int? subject;
  String? subjectName;

  TimetableEntryDomainModel({
    required this.id,
    required this.start,
    required this.end,
    required this.dayOfWeek,
    required this.subject,
    required this.subjectName,
  });

  TimetableEntryDomainModel.fromLocalModel(TimetableEntryLocalModel l) {
    this.id = l.id;
    this.start = l.start;
    this.end = l.end;
    this.dayOfWeek = l.dayOfWeek;
    this.subject = l.subject;
    this.subjectName = l.subjectName;
  }

  TimetableEntryLocalModel toLocalModel() {
    return TimetableEntryLocalModel(
      id: this.id,
      start: this.start,
      end: this.end,
      dayOfWeek: this.dayOfWeek,
      subject: this.subject,
      subjectName: this.subjectName,
    );
  }

  TimetableEntryDomainModel copyWith({
    int? id,
    int? start,
    int? end,
    int? dayOfWeek,
    int? subject,
    String? subjectName,
  }) {
    return TimetableEntryDomainModel(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      subject: subject ?? this.subject,
      subjectName: subjectName ?? this.subjectName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start': start,
      'end': end,
      'dayOfWeek': dayOfWeek,
      'subject': subject,
      'subjectName': subjectName,
    };
  }

  static TimetableEntryDomainModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return TimetableEntryDomainModel(
      id: map['id'],
      start: map['start'],
      end: map['end'],
      dayOfWeek: map['dayOfWeek'],
      subject: map['subject'],
      subjectName: map['subjectName'],
    );
  }

  String toJson() => json.encode(toMap());

  static TimetableEntryDomainModel? fromJson(String source) =>
      TimetableEntryDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TimetableEntryDomainModel(id: $id, start: $start, end: $end, dayOfWeek: $dayOfWeek, subject: $subject, subjectName: $subjectName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TimetableEntryDomainModel &&
        o.id == id &&
        o.start == start &&
        o.end == end &&
        o.dayOfWeek == dayOfWeek &&
        o.subject == subject &&
        o.subjectName == subjectName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        start.hashCode ^
        end.hashCode ^
        dayOfWeek.hashCode ^
        subject.hashCode ^
        subjectName.hashCode;
  }
}
