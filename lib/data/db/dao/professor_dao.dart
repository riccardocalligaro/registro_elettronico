import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/professor_table.dart';

part 'professor_dao.g.dart';

@UseDao(tables: [Professors])
class ProfessorDao extends DatabaseAccessor<AppDatabase>
    with _$ProfessorDaoMixin {
  AppDatabase db;
  ProfessorDao(this.db) : super(db);

  Future insertProfessor(Insertable<Professor> professor) =>
      into(professors).insert(professor, orReplace: true);

  Future insertProfessors(List<Professor> professorsList) =>
      into(professors).insertAll(professorsList, orReplace: true);

  Future deleteAllProfessors() => delete(professors).go();
  Future<List<Professor>> getAllProfessors() {
    return customSelectQuery(
      'SELECT DISTINCT * FROM professors',
      readsFrom: {
        professors,
      },
    ).map((row) {
      return Professor.fromData(row.data, db);
    }).get();
  }
}
