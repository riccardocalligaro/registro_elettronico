import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/subject_table.dart';

part 'subject_dao.g.dart';

@UseDao(tables: [Subjects])
class SubjectDao extends DatabaseAccessor<AppDatabase> with _$SubjectDaoMixin {
  AppDatabase db;
  SubjectDao(this.db) : super(db);
  Future insertSubject(Insertable<Subject> subject) =>
      into(subjects).insert(subject, orReplace: true);

  Future insertSubjects(List<Subject> subjectsList) =>
      into(subjects).insertAll(subjectsList, orReplace: true);

  Future<List<Subject>> getAllSubjects() => select(subjects).get();

  Future<List<Subject>> getSubjectsOrdered() {
    return (select(subjects)
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future deleteAllSubjects() => delete(subjects).go();
}
