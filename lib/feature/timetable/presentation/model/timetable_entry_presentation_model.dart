import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/timetable/domain/model/timetable_entry_domain_model.dart';
import 'package:timetable/timetable.dart';

class TimetableEntryPresentationModel extends Event {
  const TimetableEntryPresentationModel({
    required int? id,
    required DateTime start,
    required DateTime end,
    required this.color,
    required this.subjectId,
    required this.subjectName,
  })  : assert(subjectName != null),
        super(start: start, end: end);

  final Color? color;

  final int? subjectId;

  final String subjectName;

  TimetableEntryLocalModel toLocalModel() {
    return TimetableEntryLocalModel(
      start: this.start.hour,
      end: this.end.hour,
      dayOfWeek: this.start.weekday,
      subject: this.subjectId,
      subjectName: this.subjectName,
    );
  }

  static TimetableEntryPresentationModel fromDomainModel({
    required TimetableEntryDomainModel l,
    required Color? color,
  }) {
    // abbiamo il numero del giorno
    // dobbiamo trovare il giorno della settimana più vicino a quella data

    final _firstDayOfWeek = _findFirstDateOfTheWeek(DateTime.now());

    final day = DateTime(_firstDayOfWeek.year, _firstDayOfWeek.month,
        _firstDayOfWeek.day + l.dayOfWeek!, 8);

    day.add(Duration(hours: l.start!));

    final start = day.add(Duration(hours: l.start!));
    final end = start.add(Duration(hours: (l.end! - l.start!) + 1));

    return TimetableEntryPresentationModel(
      id: l.id,
      start: start,
      end: end,
      color: color,
      subjectId: l.subject,
      subjectName: l.subjectName!,
    );
  }

  static DateTime _findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  @override
  bool operator ==(Object? o) {
    if (identical(this, o)) return true;

    return o is TimetableEntryPresentationModel &&
        o.color == color &&
        o.subjectId == subjectId &&
        o.subjectName == subjectName;
  }

  @override
  int get hashCode =>
      color.hashCode ^ subjectId.hashCode ^ subjectName.hashCode;
}
