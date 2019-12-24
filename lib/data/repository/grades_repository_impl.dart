import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/grade_mapper.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';

class GradesRepositoryImpl implements GradesRepository {
  GradeDao gradeDao;
  SpaggiariClient spaggiariClient;
  GradeMapper gradeMapper;
  ProfileDao profileDao;

  GradesRepositoryImpl(
      this.gradeDao, this.spaggiariClient, this.gradeMapper, this.profileDao);

  @override
  Future updateGrades() async {
    final profile = await profileDao.getProfile();
    final gradesResponse = await spaggiariClient.getGrades(profile.studentId);
    print("got response");
    gradesResponse.grades.forEach((grade) {
      gradeDao.insertGrade(gradeMapper.convertGradeEntityToInserttable(grade));
    });
  }

  @override
  Future insertGrade(Grade grade) {
    return gradeDao.insertGrade(grade);
  }

  @override
  Future insertGrades(List<Grade> gradesData) {
    return gradeDao.insertGrades(gradesData);
  }

  @override
  Stream<List<Grade>> watchAllGrades() {
    return gradeDao.watchAllGrades();
  }

  @override
  Stream<List<Grade>> watchAllGradesOrdered() {
    return gradeDao.watchAllGradesOrdered();
  }

  @override
  Stream<List<Grade>> watchNumberOfGradesByDate(int number) {
    return gradeDao.watchNumberOfGradesByDate(number);
  }

  @override
  Stream<List<Grade>> watchLastGrades() {
    return gradeDao.watchLastGrades();
  }

  @override
  Future deleteAllGrades() {
    return gradeDao.deleteAllGrades();
  }

  @override
  Future<List<Grade>> getAllGrades() {
    return gradeDao.getAllGrades();
  }

  @override
  Future<List<Grade>> getAllGradesOrdered() {
    return gradeDao.getAllGradesOrdered();
  }
}
