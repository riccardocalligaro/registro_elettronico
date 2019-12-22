import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class GradesRepository {
  /// updates the grades in the database
  Future updateGrades();

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

  /// Gets the grades in the descending order
  Future<List<Grade>> getAllGradesOrdered();

  /// Future of all grades in the table
  Future<List<Grade>> getAllGrades();

  ///Delete all grades
  Future deleteAllGrades();

  /// Inserts a single grade into the database
  Future insertGrade(Grade grade);
}
