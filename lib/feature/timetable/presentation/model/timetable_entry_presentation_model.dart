import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/timetable/domain/model/timetable_entry_domain_model.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class TimetableEntryPresentationModel extends Event {
  const TimetableEntryPresentationModel({
    @required int id,
    @required LocalDateTime start,
    @required LocalDateTime end,
    @required this.color,
    @required this.subjectId,
    @required this.subjectName,
  })  : assert(subjectName != null),
        super(id: id, start: start, end: end);

  final Color color;

  final int subjectId;

  final String subjectName;

  TimetableEntryLocalModel toLocalModel() {
    return TimetableEntryLocalModel(
      start: this.start.hourOfDay,
      end: this.end.hourOfDay,
      dayOfWeek: this.start.dayOfWeek.value,
      subject: this.subjectId,
      subjectName: this.subjectName,
    );
  }

  static TimetableEntryPresentationModel fromDomainModel({
    @required TimetableEntryDomainModel l,
    @required Color color,
  }) {
    // abbiamo il numero del giorno
    // dobbiamo trovare il giorno della settimana più vicino a quella data

    final _firstDayOfWeek = _findFirstDateOfTheWeek(DateTime.now());
    print(_firstDayOfWeek);

    final day = DateTime(_firstDayOfWeek.year, _firstDayOfWeek.month,
        _firstDayOfWeek.day + l.dayOfWeek, 8);

    final localTime = LocalDateTime.dateTime(day);
    localTime.addHours(l.start);

    final start = localTime.addHours(l.start);
    final end = start.addHours((l.end - l.start) + 1);

    return TimetableEntryPresentationModel(
      id: l.id,
      start: start,
      end: end,
      color: color,
      subjectId: l.subject,
      subjectName: l.subjectName,
    );
  }

  static DateTime _findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TimetableEntryPresentationModel &&
        o.color == color &&
        o.subjectId == subjectId &&
        o.subjectName == subjectName;
  }

  @override
  int get hashCode =>
      color.hashCode ^ subjectId.hashCode ^ subjectName.hashCode;

  @override
  String toString() =>
      'TimetableEntryPresentationModel(color: $color, subjectId: $subjectId, subjectName: $subjectName)';
}
