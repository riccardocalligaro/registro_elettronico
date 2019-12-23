import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/subject_table.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

part 'subject_dao.g.dart';

@UseDao(tables: [Subjects])
class SubjectDao extends DatabaseAccessor<AppDatabase> with _$SubjectDaoMixin {
  AppDatabase db;
  SubjectDao(this.db) : super(db);
  Future insertSubject(Insertable<Subject> subject) =>
      into(subjects).insert(subject, orReplace: true);

  Stream<List<Subject>> watchAllSubjects() => select(subjects).watch();

  Future<List<Subject>> getAllSubjects() => select(subjects).get();

  Stream<List<Subject>> watchRelevanantSubjects() {
    return (select(subjects)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .watch();
  }
}
