import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class SubjectsRepository {
  Future updateSubjects(String studentId);

  ///Stream of all subject
  Stream<List<Subject>> watchAllSubjects();

  ///Insert one subject into db
  Future insertSubject(Subject subject);

  ///Stream of subject that are not sostegno
  Stream<List<Subject>> watchRelevanantSubjects();
}
