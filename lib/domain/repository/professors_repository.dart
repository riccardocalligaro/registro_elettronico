import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class ProfessorsRepository {
  ///Insert a professor db entity
  Future insertProfessor(Professor professor);

  ///Stream of all professors
  Stream<List<Professor>> watchAllProfessors();
}
