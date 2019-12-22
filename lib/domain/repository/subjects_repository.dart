import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class SubjectsRepository {
  Future updateSubjects();

  /// Inserts a single subject into the database
  Future insertSubject(Subject subject);

  /// Future of all subjects
  Future<List<Subject>> getAllSubjects();

  /// Stream of all subjects
  Stream<List<Subject>> watchAllSubjects();

  /// Stream of subjects without sostegno
  Stream<List<Subject>> watchRelevantSubjects();

  /// Stream of all professors
  Stream<List<Professor>> watchAllProfessors();
}
