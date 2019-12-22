import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/subject_mapper.dart';
import 'package:registro_elettronico/domain/repository/subjects_repository.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  SpaggiariClient spaggiariClient;
  ProfessorDao professorDao;
  SubjectDao subjectDao;
  SubjectMapper subjectMapper;
  ProfileDao profileDao;

  SubjectsRepositoryImpl(
    this.spaggiariClient,
    this.professorDao,
    this.subjectDao,
    this.subjectMapper,
    this.profileDao,
  );

  @override
  Future updateSubjects() async {
    final profile = await profileDao.getProfile();
    final res = await spaggiariClient.getSubjects(profile.studentId);

    res.subjects.forEach((subject) {
      subjectDao.insertSubject(
          subjectMapper.convertSubjectEntityToInsertable(subject));
      subject.teachers.forEach((professor) {
        professorDao.insertProfessor(subjectMapper
            .convertProfessorEntityToInsertable(professor, subject.id));
      });
    });
  }

  @override
  Stream<List<Subject>> watchAllSubjects() {
    return subjectDao.watchAllSubjects();
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
  Stream<List<Subject>> watchRelevantSubjects() {
    return subjectDao.watchRelevanantSubjects();
  }

  @override
  Stream<List<Professor>> watchAllProfessors() {
    return professorDao.watchAllProfessors();
  }
}
