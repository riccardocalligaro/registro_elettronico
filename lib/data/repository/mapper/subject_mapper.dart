import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/subjects/subjects_response.dart';

class SubjectMapper {
  /// Converts a lesson we got from the api to an insertable in the database
  db.Subject convertSubjectEntityToInsertable(Subjects subject) {
    return db.Subject(
        id: subject.id, name: subject.description, orderNumber: subject.order);
  }

  db.Professor convertProfessorEntityToInsertable(Teachers professor) {
    return db.Professor(id: professor.teacherId, name: professor.teacherName);
  }
}
