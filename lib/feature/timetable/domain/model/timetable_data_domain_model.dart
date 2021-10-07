import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/feature/timetable/presentation/model/timetable_entry_presentation_model.dart';

class TimetableDataDomainModel {
  List<TimetableEntryPresentationModel> entries;
  List<SubjectDomainModel> subjects;
  Map<DateTime, List<TimetableEntryPresentationModel>> entriesMap;
  Map<Tuple2, List<TimetableEntryPresentationModel>> entriesMapForDragging;

  TimetableDataDomainModel({
    required this.entries,
    required this.subjects,
    required this.entriesMap,
    required this.entriesMapForDragging,
  });

  @override
  String toString() =>
      'TimetableDataDomainModel(entries: $entries, subjects: $subjects)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TimetableDataDomainModel &&
        listEquals(o.entries, entries) &&
        listEquals(o.subjects, subjects);
  }

  @override
  int get hashCode => entries.hashCode ^ subjects.hashCode;
}
