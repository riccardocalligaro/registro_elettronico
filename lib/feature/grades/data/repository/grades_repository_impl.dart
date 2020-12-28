import 'package:f_logs/model/flog/flog.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/feature/grades/data/dao/grade_dao.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_mapper.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradesRepositoryImpl implements GradesRepository {
  final GradeDao gradeDao;
  final SpaggiariClient spaggiariClient;
  final ProfileDao profileDao;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final ProfileRepository profileRepository;

  GradesRepositoryImpl(
    this.gradeDao,
    this.spaggiariClient,
    this.profileDao,
    this.networkInfo,
    this.sharedPreferences,
    this.profileRepository,
  );

  @override
  Future updateGrades() async {
    if (await networkInfo.isConnected) {
      final profile = await profileRepository.getProfile();
      final gradesResponse = await spaggiariClient.getGrades(profile.studentId);
      List<Grade> grades = [];
      gradesResponse.grades.forEach((grade) {
        grades.add(GradeMapper.convertGradeEntityToInserttable(grade));
      });

      FLog.info(
        text:
            'Got ${gradesResponse.grades.length} grades from server, procceding to insert in database',
      );
      await gradeDao.deleteAllGrades();
      await gradeDao.insertGrades(grades);

      await sharedPreferences.setInt(
        PrefsConstants.lastUpdateGrades,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future insertGrade(Grade grade) async {
    return gradeDao.insertGrade(grade);
  }

  @override
  Future insertGrades(List<Grade> gradesData) async {
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
  Future insertLocalGrade(LocalGrade localGrade) async {
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
