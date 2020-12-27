import 'package:registro_elettronico/core/data/local/moor_database.dart';

abstract class SubjectsRepository {
  Future updateSubjects();

  /// Inserts a single subject into the database
  Future insertSubject(Subject subject);

  /// Future of all subjects
  Future<List<Subject>> getAllSubjects();

  /// Stream of all subjects
  Future<List<Subject>> getSubjectsOrdered();

  /// Stream of all professors
  Future<List<Professor>> getAllProfessors();
}
