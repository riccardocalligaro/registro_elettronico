import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/timetable/data/model/timetale_local_model.dart';

part 'timetable_dao.g.dart';

@UseDao(tables: [TimetableEntries])
class TimetableDao extends DatabaseAccessor<AppDatabase>
    with _$TimetableDaoMixin {
  AppDatabase db;

  TimetableDao(this.db) : super(db);

  Future<List<TimetableEntry>> getTimetable() {
    return customSelect('SELECT * FROM timetable_entries')
        .map((row) => TimetableEntry.fromData(row.data, db))
        .get();
  }

  Future deleteTimetable() => delete(timetableEntries).go();

  Future deleteTimetableEntry(TimetableEntry entry) =>
      delete(timetableEntries).delete(entry);

  Future deleteTimetableEntryWithInfo(int dayOfWeek, int begin, int end) {
    return (delete(timetableEntries)
          ..where(
            (t) =>
                t.dayOfWeek.equals(dayOfWeek) &
                t.start.equals(begin) &
                t.end.equals(end),
          ))
        .go();
  }

  Future<void> insertTimetableEntries(List<TimetableEntry> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(timetableEntries, entries);
    });
  }

  Future insertTimetableEntry(TimetableEntry entry) =>
      into(timetableEntries).insertOnConflictUpdate(entry);

  Future updateTimetableEntry(TimetableEntry entry) =>
      update(timetableEntries).replace(entry);
}
