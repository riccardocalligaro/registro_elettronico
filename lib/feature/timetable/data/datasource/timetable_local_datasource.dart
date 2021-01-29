import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/timetable/data/model/timetable_entry_local_model.dart';

part 'timetable_local_datasource.g.dart';

@UseDao(tables: [TimetableEntries])
class TimetableLocalDatasource extends DatabaseAccessor<SRDatabase>
    with _$TimetableLocalDatasourceMixin {
  SRDatabase db;

  TimetableLocalDatasource(this.db) : super(db);

  Stream<List<TimetableEntryLocalModel>> watchAllEntries() =>
      select(timetableEntries).watch();

  Future deleteEntries() => delete(timetableEntries).go();

  Future deleteTimetableEntry(TimetableEntryLocalModel entry) =>
      delete(timetableEntries).delete(entry);

  Future<void> insertTimetableEntries(
      List<TimetableEntryLocalModel> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(timetableEntries, entries);
    });
  }

  Future insertTimetableEntry(TimetableEntryLocalModel entry) =>
      into(timetableEntries).insertOnConflictUpdate(entry);

  Future updateTimetableEntry(TimetableEntryLocalModel entry) =>
      update(timetableEntries).replace(entry);

  Future deleteEntryWithId(int id) {
    return (delete(timetableEntries)..where((t) => t.id.equals(id))).go();
  }
}
