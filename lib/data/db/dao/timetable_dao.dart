import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/timetable_table.dart';

part 'timetable_dao.g.dart';

@UseDao(tables: [TimetableEntries])
class TimetableDao extends DatabaseAccessor<AppDatabase>
    with _$TimetableDaoMixin {
  AppDatabase db;
  TimetableDao(this.db) : super(db);

  //Future<List<TimetableEntry>> getTimetable() => select(timetableEntries).get();
  Future<List<TimetableEntry>> getTimetable() {
    return customSelectQuery(
            'SELECT * FROM timetable_entries')
        .map((row) => TimetableEntry.fromData(row.data, db))
        .get();
  }

  Future deleteTimetable() => delete(timetableEntries).go();

  Future insertTimetableEntries(List<TimetableEntry> entries) =>
      into(timetableEntries).insertAll(entries, orReplace: true);

  Future insertTimetableEntry(TimetableEntry entry) =>
      into(timetableEntries).insert(entry, orReplace: true);

  Future updateTimetableEntry(TimetableEntry entry) =>
      update(timetableEntries).replace(entry);
}
