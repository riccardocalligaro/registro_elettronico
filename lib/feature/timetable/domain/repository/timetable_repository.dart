import 'package:registro_elettronico/core/data/local/moor_database.dart';

abstract class TimetableRepository {
  /// Checks the lessons and [updates] the timetable
  Future updateTimeTable();

  /// Gets [all] events of the [timetable]
  Future<List<TimetableEntry>> getTimetable();

  /// Deletes [all] events from the timetable
  Future deleteTimetable();

  /// Inserts [multiple] entries
  Future insertTimetableEntries(List<TimetableEntry> entries);

  /// Inserts a [single] entry
  Future insertTimetableEntry(TimetableEntry entry);

  /// Updates an entry looking at the [eventId]
  Future updateTimetableEntry(TimetableEntry entry);

  Future deleteTimetableEntry(TimetableEntry entry);

  Future deleteTimetableEntryWithDate(int dayOfWeek, int begin, int end);
}
