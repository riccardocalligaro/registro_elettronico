import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/subjects/data/model/subject_local_model.dart';

part 'subject_local_datasource.g.dart';

@UseDao(tables: [
  Subjects,
])
class SubjectsLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$SubjectsLocalDatasourceMixin {
  AppDatabase db;

  SubjectsLocalDatasource(this.db) : super(db);

  Future<void> insertSubjects(List<SubjectLocalModel> subjectsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(subjects, subjectsList);
    });
  }

  Future<List<SubjectLocalModel>> getAllSubjects() => select(subjects).get();

  Stream<List<SubjectLocalModel>> watchAllSubjects() =>
      select(subjects).watch();

  Future<void> deleteSubjects(List<SubjectLocalModel> subjectsToDelete) async {
    await batch((batch) {
      subjectsToDelete.forEach((entry) {
        batch.delete(subjects, entry);
      });
    });
  }
}
