import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/professors/data/model/professor_table.dart';

part 'professor_dao.g.dart';

@UseDao(tables: [Professors])
class ProfessorDao extends DatabaseAccessor<AppDatabase>
    with _$ProfessorDaoMixin {
  AppDatabase db;

  ProfessorDao(this.db) : super(db);

  Future insertProfessor(Insertable<Professor> professor) =>
      into(professors).insertOnConflictUpdate(professor);

  Future<void> insertProfessors(List<Professor> professorsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(professors, professorsList);
    });
  }

  Future deleteAllProfessors() => delete(professors).go();

  Future<List<Professor>> getAllProfessors() {
    return customSelect(
      'SELECT DISTINCT * FROM professors',
      readsFrom: {
        professors,
      },
    ).map((row) {
      return Professor.fromData(row.data, db);
    }).get();
  }
}
