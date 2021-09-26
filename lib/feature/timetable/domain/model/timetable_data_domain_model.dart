import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/feature/timetable/presentation/model/timetable_entry_presentation_model.dart';

class TimetableDataDomainModel {
  List<TimetableEntryPresentationModel>? entries;
  List<SubjectDomainModel>? subjects;

  TimetableDataDomainModel({
    this.entries,
    this.subjects,
  });

  TimetableDataDomainModel copyWith({
    List<TimetableEntryPresentationModel>? entries,
    List<SubjectDomainModel>? subjects,
  }) {
    return TimetableDataDomainModel(
      entries: entries ?? this.entries,
      subjects: subjects ?? this.subjects,
    );
  }

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
