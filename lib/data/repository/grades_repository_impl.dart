import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/grade_mapper.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';

class GradesRepositoryImpl implements GradesRepository {
  GradeDao gradeDao;
  SpaggiariClient spaggiariClient;
  GradeMapper gradeMapper;

  GradesRepositoryImpl(this.gradeDao, this.spaggiariClient, this.gradeMapper);

  @override
  Future updateGrades(String studentId) async {
    final gradesResponse = await spaggiariClient.getGrades(studentId);
    print("GOT RESPOMSE");
    gradesResponse.grades.forEach((grade) {
      gradeDao.insertGrade(gradeMapper.convertGradeEntityToInserttable(grade));
    });
    print("INSERTED");
  }

  @override
  Future<List<Grade>> getGrades(String studentId) {
    //todo: implement get grades
    return null;
  }
}
