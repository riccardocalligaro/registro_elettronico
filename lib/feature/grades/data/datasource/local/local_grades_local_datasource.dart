import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
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

  Future<List<LocalGrade>> getGrades() => select(localGrades).get();

  Future insertGrade(LocalGrade localGrade) =>
      into(localGrades).insertOnConflictUpdate(localGrade);

  Future deleteGrade(LocalGrade localGrade) =>
      delete(localGrades).delete(localGrade);

  Future updateGrade(LocalGrade localGrade) =>
      update(localGrades).replace(localGrade);
}
