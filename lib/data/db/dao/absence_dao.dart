import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/absence_table.dart';

part 'absence_dao.g.dart';

@UseDao(tables: [Absences])
class AbsenceDao extends DatabaseAccessor<AppDatabase> with _$AbsenceDaoMixin {
  AppDatabase db;
  AbsenceDao(this.db) : super(db);

  Stream<List<Absence>> watchAllAbsences() => select(absences).watch();

  Future insertEvent(Absence absence) =>
      into(absences).insert(absence, orReplace: true);
}
