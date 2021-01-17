import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/model/local_grade_local_model.dart';

part 'grades_local_datasource.g.dart';

@UseDao(tables: [
  Grades,
  LocalGrades,
])
class GradesLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$GradesLocalDatasourceMixin {
  AppDatabase appDatabase;

  GradesLocalDatasource(this.appDatabase) : super(appDatabase);

  Stream<List<GradeLocalModel>> watchGrades() => select(grades).watch();

  Future<List<GradeLocalModel>> getGrades() => select(grades).get();

  Future<List<LocalGrade>> getLocalGrades() => select(localGrades).get();

  Future<List<GradeLocalModel>> getAllGradesOrdered() {
    return (select(grades)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.eventDate, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<List<GradeLocalModel>> getNumberOfGradesByDate(int number) {
    return ((select(grades)
          ..orderBy(
              [(grade) => OrderingTerm(expression: grade.eventDate, mode: OrderingMode.desc)]))
          ..limit(number))
        .get();
  }

  Future<List<GradeLocalModel>> getLastGrades() {
    return customSelect("""
        SELECT DISTINCT * FROM grades ORDER BY event_date DESC LIMIT 2""",
        readsFrom: {
          grades,
        }).map((row) {
      return GradeLocalModel.fromData(row.data, db);
    }).get();
  }

  Future insertGrade(GradeLocalModel grade) =>
      into(grades).insertOnConflictUpdate(grade);

  Future<void> insertGrades(List<GradeLocalModel> gradesData) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(grades, gradesData);
    });
  }

  Future deleteAllGrades() => delete(grades).go();

  Future<void> deleteGrades(List<GradeLocalModel> gradesToDelete) async {
    await batch((batch) {
      gradesToDelete.forEach((entry) {
        batch.delete(grades, entry);
      });
    });
  }

  Future deleteGrade(GradeLocalModel grade) => delete(grades).delete(grade);

  Future updateGrade(GradeLocalModel grade) => update(grades).replace(grade);
}
