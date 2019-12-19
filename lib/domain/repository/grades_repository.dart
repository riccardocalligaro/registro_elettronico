import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class GradesRepository {
  /// updates the grades in the database
  Future updateGrades(String studentId);

  /// gets all the grades
  Future<List<Grade>> getGrades(String studentId);

  /// Given a list it inserts a list of grades
  Future insertGrades(List<Grade> gradesData);

  ///Gets all grades
  Stream<List<Grade>> watchAllGrades();

  ///Gets all grades ordered by date
  Stream<List<Grade>> watchAllGradesOrdered();

  ///Gets number of grades by a date
  Stream<List<Grade>> watchNumberOfGradesByDate(int number);

  ///Gets last grades
  Stream<List<Grade>> watchLastGrades();

  ///Delete all grades
  Future deleteAllGrades();

  /// Inserts a single grade into the database
  Future insertGrade(Grade grade);
}
