import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/subjects/data/model/subject_local_model.dart';

part 'subject_dao.g.dart';

@UseDao(tables: [Subjects])
class SubjectDao extends DatabaseAccessor<AppDatabase> with _$SubjectDaoMixin {
  AppDatabase db;

  SubjectDao(this.db) : super(db);

  Future insertSubject(Insertable<Subject> subject) =>
      into(subjects).insertOnConflictUpdate(subject);

  Future<void> insertSubjects(List<Subject> subjectsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(subjects, subjectsList);
    });
  }

  Future<List<Subject>> getAllSubjects() => select(subjects).get();

  Stream<List<Subject>> watchAllSubjects() => select(subjects).watch();

  Future<List<Subject>> getSubjectsOrdered() {
    return (select(subjects)
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future deleteAllSubjects() => delete(subjects).go();
}
