import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class GradesRepository {
  /// updates the grades in the database
  Future updateGrades();

  /// Given a list it inserts a list of grades
  Future insertGrades(List<Grade> gradesData);

  ///Gets all grades ordered by date
  Future<List<Grade>> getAllGradesOrdered();

  ///Gets number of grades by a date
  Future<List<Grade>> getNumberOfGradesByDate(int number);

  ///Gets last grades
  Future<List<Grade>> getLastGrades();

  /// Future of all grades in the table
  Future<List<Grade>> getAllGrades();

  ///Delete all grades
  Future deleteAllGrades();

  /// Inserts a single grade into the database
  Future insertGrade(Grade grade);

  Future insertLocalGrade(LocalGrade localGrade);

  Future deleteLocalGrade(LocalGrade localGrade);

  Future updateLocalGrade(LocalGrade localGrade);

  Future updateGrade(Grade grade);

  Future<List<LocalGrade>> getLocalGrades();
}
