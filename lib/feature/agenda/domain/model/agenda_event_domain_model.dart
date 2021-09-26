import 'dart:convert';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class AgendaEventDomainModel {
  int? id;
  String? code;
  DateTime? begin;
  DateTime? end;
  bool? isFullDay;
  String? notes;
  String? author;
  String? className;
  int? subjectId;
  String? subjectName;
  bool? isLocal;
  String? labelColor;
  String? title;

  AgendaEventDomainModel({
    this.id,
    this.code,
    this.begin,
    this.end,
    this.isFullDay,
    this.notes,
    this.author,
    this.className,
    this.subjectId,
    this.subjectName,
    this.isLocal,
    this.labelColor,
    this.title,
  });

  AgendaEventDomainModel.fromLocalModel(AgendaEventLocalModel l) {
    this.id = l.evtId;
    this.code = l.evtCode;
    this.begin = l.begin;
    this.end = l.end;
    this.isFullDay = l.isFullDay;
    this.notes = l.notes;
    this.author = l.authorName;
    this.className = l.classDesc;
    this.subjectId = l.subjectId;
    this.subjectName = l.subjectDesc;
    this.isLocal = l.isLocal;
    this.labelColor = l.labelColor;
    this.title = l.title;
  }

  AgendaEventLocalModel toLocalModel() {
    return AgendaEventLocalModel(
      evtId: this.id ?? -1,
      evtCode: this.code ?? '',
      begin: this.begin ?? DateTime.fromMillisecondsSinceEpoch(0),
      end: this.end ?? DateTime.fromMillisecondsSinceEpoch(0),
      isFullDay: this.isFullDay ?? false,
      notes: this.notes ?? '',
      authorName: this.author ?? '',
      classDesc: this.className ?? '',
      subjectId: this.subjectId ?? 0,
      subjectDesc: this.subjectName ?? '',
      isLocal: this.isLocal ?? false,
      labelColor: this.labelColor,
      title: this.title ?? '',
    );
  }

  AgendaEventDomainModel copyWith({
    int? id,
    String? code,
    DateTime? begin,
    DateTime? end,
    bool? isFullDay,
    String? notes,
    String? author,
    String? className,
    int? subjectId,
    String? subjectName,
    bool? isLocal,
    String? labelColor,
    String? title,
  }) {
    return AgendaEventDomainModel(
      id: id ?? this.id,
      code: code ?? this.code,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      isFullDay: isFullDay ?? this.isFullDay,
      notes: notes ?? this.notes,
      author: author ?? this.author,
      className: className ?? this.className,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      isLocal: isLocal ?? this.isLocal,
      labelColor: labelColor ?? this.labelColor,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'begin': begin?.millisecondsSinceEpoch,
      'end': end?.millisecondsSinceEpoch,
      'isFullDay': isFullDay,
      'notes': notes,
      'author': author,
      'className': className,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'isLocal': isLocal,
      'labelColor': labelColor,
      'title': title,
    };
  }

  factory AgendaEventDomainModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return AgendaEventDomainModel(
      id: map['id'],
      code: map['code'],
      begin: DateTime.fromMillisecondsSinceEpoch(map['begin']),
      end: DateTime.fromMillisecondsSinceEpoch(map['end']),
      isFullDay: map['isFullDay'],
      notes: map['notes'],
      author: map['author'],
      className: map['className'],
      subjectId: map['subjectId'],
      subjectName: map['subjectName'],
      isLocal: map['isLocal'],
      labelColor: map['labelColor'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AgendaEventDomainModel.fromJson(String source) =>
      AgendaEventDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AgendaEventDomainModel(id: $id, code: $code, begin: $begin, end: $end, isFullDay: $isFullDay, notes: $notes, author: $author, className: $className, subjectId: $subjectId, subjectName: $subjectName, isLocal: $isLocal, labelColor: $labelColor, title: $title)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AgendaEventDomainModel &&
        o.id == id &&
        o.code == code &&
        o.begin == begin &&
        o.end == end &&
        o.isFullDay == isFullDay &&
        o.notes == notes &&
        o.author == author &&
        o.className == className &&
        o.subjectId == subjectId &&
        o.subjectName == subjectName &&
        o.isLocal == isLocal &&
        o.labelColor == labelColor &&
        o.title == title;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        begin.hashCode ^
        end.hashCode ^
        isFullDay.hashCode ^
        notes.hashCode ^
        author.hashCode ^
        className.hashCode ^
        subjectId.hashCode ^
        subjectName.hashCode ^
        isLocal.hashCode ^
        labelColor.hashCode ^
        title.hashCode;
  }
}
