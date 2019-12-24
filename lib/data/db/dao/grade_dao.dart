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

  Future<List<Grade>> getAllGrades() => select(grades).get();

  Future<List<Grade>> getAllGradesOrdered() {
    return (select(grades)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.eventDate, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Stream<List<Grade>> watchAllGradesOrdered() {
    return (select(grades)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.eventDate, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Stream<List<Grade>> watchNumberOfGradesByDate(int number) {
    return ((select(grades)
          ..orderBy(
              [(grade) => OrderingTerm(expression: grade.eventDate, mode: OrderingMode.desc)]))
          ..limit(number))
        .watch();
  }

  Stream<List<Grade>> watchLastGrades() {
    return customSelectQuery("""
        SELECT DISTINCT * FROM grades ORDER BY event_date DESC LIMIT 2""",
        readsFrom: {
          grades,
        }).watch().map((rows) {
      return rows.map((row) => Grade.fromData(row.data, db)).toList();
    });
  }

  Future deleteAllGrades() =>
      (delete(grades)..where((entry) => entry.evtId.isBiggerOrEqualValue(-1)))
          .go();
          
  Future deleteGrade(Grade grade) => delete(grades).delete(grade);
}
