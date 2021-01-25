import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/professors/data/model/professor_local_model.dart';

part 'professors_local_datasource.g.dart';

@UseDao(tables: [Professors])
class ProfessorLocalDatasource extends DatabaseAccessor<SRDatabase>
    with _$ProfessorLocalDatasourceMixin {
  SRDatabase db;

  ProfessorLocalDatasource(this.db) : super(db);

  Future<List<ProfessorLocalModel>> getProfessorsForSubject(int id) {
    return (select(professors)..where((p) => p.subjectId.equals(id))).get();
  }

  Stream<List<ProfessorLocalModel>> watchAllProfessors() =>
      select(professors).watch();

  Future<List<ProfessorLocalModel>> getAllProfessors() =>
      select(professors).get();

  Future<void> insertProfessors(
      List<ProfessorLocalModel> professorsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(professors, professorsList);
    });
  }

  Future deleteAllProfessors() => delete(professors).go();

  Future<void> deleteProfessors(
      List<SubjectLocalModel> subjectsToDelete) async {
    await batch((batch) {
      subjectsToDelete.forEach((entry) {
        batch.delete(professors, entry);
      });
    });
  }
}
