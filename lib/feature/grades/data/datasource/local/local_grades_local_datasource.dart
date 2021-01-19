import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/data/model/local_grade_local_model.dart';

part 'local_grades_local_datasource.g.dart';

@UseDao(tables: [
  LocalGrades,
])
class LocalGradesLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$LocalGradesLocalDatasourceMixin {
  AppDatabase appDatabase;

  LocalGradesLocalDatasource(this.appDatabase) : super(appDatabase);

  Stream<List<LocalGrade>> watchGrades() => select(localGrades).watch();

  Stream<List<LocalGrade>> watchGradesForSubject(int id, int periodPos) {
    if (periodPos == -1) {
      return (select(localGrades)..where((p) => p.subjectId.equals(id)))
          .watch();
    } else {
      return (select(localGrades)
            ..where(
                (p) => p.subjectId.equals(id) & p.periodPos.equals(periodPos)))
          .watch();
    }
  }

  Future<List<LocalGrade>> getGrades() => select(localGrades).get();

  Future insertGrade(LocalGrade localGrade) =>
      into(localGrades).insertOnConflictUpdate(localGrade);

  Future deleteGrade(LocalGrade localGrade) =>
      delete(localGrades).delete(localGrade);

  Future deleteGradeWithId(int id) {
    return (delete(localGrades)..where((t) => t.id.equals(id))).go();
  }

  Future updateGrade(LocalGrade localGrade) =>
      update(localGrades).replace(localGrade);
}
