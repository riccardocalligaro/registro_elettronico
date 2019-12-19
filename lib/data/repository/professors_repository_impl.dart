import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/professors_repository.dart';

class ProfessorsRepositoryImpl implements ProfessorsRepository {
  ProfessorDao professorDao;

  ProfessorsRepositoryImpl(this.professorDao);
  @override
  Future insertProfessor(Professor professor) {
    return professorDao.insertProfessor(professor);
  }

  @override
  Stream<List<Professor>> watchAllProfessors() {
    return professorDao.watchAllProfessors();
  }
}
