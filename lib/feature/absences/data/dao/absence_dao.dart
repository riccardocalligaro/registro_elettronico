import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/absences/data/model/absence_local_model.dart';

part 'absence_dao.g.dart';

@UseDao(tables: [Absences])
class AbsenceDao extends DatabaseAccessor<AppDatabase> with _$AbsenceDaoMixin {
  AppDatabase db;
  AbsenceDao(this.db) : super(db);

  Stream<List<Absence>> watchAllAbsences() => select(absences).watch();

  Future<List<Absence>> getAllAbsences() => select(absences).get();

  Future insertEvent(Absence absence) =>
      into(absences).insertOnConflictUpdate(absence);

  Future<void> insertEvents(List<Absence> absencesList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(absences, absencesList);
    });
  }

  Future deleteAllAbsences() => delete(absences).go();

  Future deleteAbsence(Absence absence) => delete(absences).delete(absence);
}
