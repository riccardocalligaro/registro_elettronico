import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class GradesRepository {
  /// updates the grades in the database
  Future updateGrades(String studentId);

  /// gets all the grades
  Future<List<Grade>> getGrades(String studentId);
}
