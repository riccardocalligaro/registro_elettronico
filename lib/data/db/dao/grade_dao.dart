import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/grade_table.dart';

part 'grade_dao.g.dart';

@UseDao(tables: [Grades])
class GradeDao extends DatabaseAccessor<AppDatabase> with _$GradeDaoMixin {
  AppDatabase db;

  GradeDao(this.db) : super(db);

  // Inserts a single grade into the database
  Future insertGrade(Grade grade) =>
      into(grades).insert(grade, orReplace: true);

  // Given a list it inserts a list of grades
  Future insertGrades(List<Grade> gradesData) =>
      into(grades).insertAll(gradesData, orReplace: true);

  Stream<List<Grade>> watchAllGrades() => select(grades).watch();

  Stream<List<Grade>> watchAllGradesByDate() {
    return (select(grades)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.eventDate, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Stream<List<Grade>> watchNumberOfGradesByDate(int number) {
    return (select(grades)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.eventDate, mode: OrderingMode.desc)
          ])
          ..limit(number))
        .watch();
  }
}
