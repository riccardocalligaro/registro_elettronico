import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/professors/data/dao/professor_dao.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/feature/subjects/data/dao/subject_dao.dart';
import 'package:registro_elettronico/feature/subjects/data/model/subject_mapper.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  final SpaggiariClient spaggiariClient;
  final ProfessorDao professorDao;
  final SubjectDao subjectDao;
  final ProfileDao profileDao;
  final NetworkInfo networkInfo;
  final ProfileRepository profileRepository;

  SubjectsRepositoryImpl(
    this.spaggiariClient,
    this.professorDao,
    this.subjectDao,
    this.profileDao,
    this.networkInfo,
    this.profileRepository,
  );

  @override
  Future updateSubjects() async {
    if (await networkInfo.isConnected) {
      final profile = await profileRepository.getProfile();
      final res = await spaggiariClient.getSubjects(profile.studentId);

      List<Subject> subjects = [];
      List<Professor> teachers = [];
      int index = 0;
      res.subjects.forEach((subject) {
        subjects.add(
            SubjectMapper.convertSubjectEntityToInsertable(subject, index));
        index++;
        subject.teachers.forEach((professor) {
          teachers.add(
            SubjectMapper.convertProfessorEntityToInsertable(
              professor,
              subject.id,
            ),
          );
        });
      });

      Logger.info(
        'Got ${res.subjects} subjects from server, procceding to insert in database',
      );
      // Clear the old profofessors and subjects from the database
      await professorDao.deleteAllProfessors();
      await subjectDao.deleteAllSubjects();

      await subjectDao.insertSubjects(subjects);
      await professorDao.insertProfessors(teachers);
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future insertSubject(Subject subject) {
    return subjectDao.insertSubject(subject);
  }

  @override
  Future<List<Subject>> getAllSubjects() {
    return subjectDao.getAllSubjects();
  }

  @override
  Future<List<Professor>> getAllProfessors() {
    return professorDao.getAllProfessors();
  }

  @override
  Future<List<Subject>> getSubjectsOrdered() {
    return subjectDao.getSubjectsOrdered();
  }
}
