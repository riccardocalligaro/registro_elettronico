import 'package:f_logs/model/flog/flog.dart';
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
    List<Grade> grades = [];
    await gradeDao.deleteAllGrades();
    gradesResponse.grades.forEach((grade) {
      grades.add(gradeMapper.convertGradeEntityToInserttable(grade));
    });

    FLog.info(
      text:
          'Got ${gradesResponse.grades.length} grades from server, procceding to insert in database',
    );
    gradeDao.insertGrades(grades);
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
  Future deleteAllGrades() {
    return gradeDao.deleteAllGrades();
  }

  @override
  Future<List<Grade>> getAllGrades() {
    return gradeDao.getAllGrades();
  }

  @override
  Future deleteLocalGrade(LocalGrade localGrade) {
    return gradeDao.deleteLocalGrade(localGrade);
  }

  @override
  Future<List<LocalGrade>> getLocalGrades() {
    return gradeDao.getLocalGrades();
  }

  @override
  Future insertLocalGrade(LocalGrade localGrade) {
    return gradeDao.insertLocalGrade(localGrade);
  }

  @override
  Future updateLocalGrade(LocalGrade localGrade) {
    return gradeDao.updateLocalGrade(localGrade);
  }

  @override
  Future updateGrade(Grade grade) {
    return gradeDao.updateGrade(grade);
  }

  @override
  Future<List<Grade>> getAllGradesOrdered() {
    return gradeDao.getAllGradesOrdered();
  }

  @override
  Future<List<Grade>> getLastGrades() {
    return gradeDao.getLastGrades();
  }

  @override
  Future<List<Grade>> getNumberOfGradesByDate(int number) {
    return gradeDao.getNumberOfGradesByDate(number);
  }

  @override
  Future cancelGradeLocally(Grade grade) {
    return gradeDao.updateGrade(grade.copyWith(localllyCancelled: true));
  }

  @override
  Future restoreGradeLocally(Grade grade) {
    return gradeDao.updateGrade(grade.copyWith(localllyCancelled: false));
  }
}
