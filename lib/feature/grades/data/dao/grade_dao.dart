import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/model/local_grade_local_model.dart';

part 'grade_dao.g.dart';

@UseDao(tables: [
  Grades,
  LocalGrades,
])
class GradeDao extends DatabaseAccessor<AppDatabase> with _$GradeDaoMixin {
  AppDatabase db;

  GradeDao(this.db) : super(db);

  // Inserts a single grade into the database
  Future insertGrade(Grade grade) =>
      into(grades).insertOnConflictUpdate(grade);

  // Given a list it inserts a list of grades
  Future<void> insertGrades(List<Grade> gradesData) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(localGrades, gradesData);
    });
  }

  Stream<List<Grade>> watchAllGrades() => select(grades).watch();

  Future<List<Grade>> getAllGrades() => select(grades).get();

  Future<List<LocalGrade>> getLocalGrades() => select(localGrades).get();

  Future<List<Grade>> getAllGradesOrdered() {
    return (select(grades)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.eventDate, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<List<Grade>> getNumberOfGradesByDate(int number) {
    return ((select(grades)
          ..orderBy(
              [(grade) => OrderingTerm(expression: grade.eventDate, mode: OrderingMode.desc)]))
          ..limit(number))
        .get();
  }

  Future<List<Grade>> getLastGrades() {
    return customSelect("""
        SELECT DISTINCT * FROM grades ORDER BY event_date DESC LIMIT 2""",
        readsFrom: {
          grades,
        }).map((row) {
      return Grade.fromData(row.data, db);
    }).get();
  }

  Future deleteAllGrades() =>
      (delete(grades)..where((entry) => entry.evtId.isBiggerOrEqualValue(-1)))
          .go();

  Future deleteGrade(Grade grade) => delete(grades).delete(grade);

  // Local Grades
  Future insertLocalGrade(LocalGrade localGrade) =>
      into(localGrades).insertOnConflictUpdate(localGrade);

  Future deleteLocalGrade(LocalGrade localGrade) =>
      delete(localGrades).delete(localGrade);

  Future updateLocalGrade(LocalGrade localGrade) =>
      update(localGrades).replace(localGrade);

  Future updateGrade(Grade grade) => update(grades).replace(grade);
}
