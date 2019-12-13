import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/component/registro_costants.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/subject_table.dart';

part 'subject_dao.g.dart';

@UseDao(tables: [Subjects])
class SubjectDao extends DatabaseAccessor<AppDatabase> with _$SubjectDaoMixin {
  AppDatabase db;
  SubjectDao(this.db) : super(db);
  Future insertSubject(Insertable<Subject> subject) =>
      into(subjects).insert(subject, orReplace: true);

  Stream<List<Subject>> watchAllSubjects() => select(subjects).watch();

  Stream<List<Subject>> watchRelevanantSubjects() => (select(subjects)
        ..where((lesson) =>
            not(lesson.name.equals(RegistroCostants.SOSTEGNO_FULL))))
      .watch();
}
