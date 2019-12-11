import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/subject_mapper.dart';
import 'package:registro_elettronico/domain/repository/subjects_repository.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  SpaggiariClient spaggiariClient;
  ProfessorDao professorDao;
  SubjectDao subjectDao;
  SubjectMapper subjectMapper;

  SubjectsRepositoryImpl(this.spaggiariClient, this.professorDao,
      this.subjectDao, this.subjectMapper);

  @override
  Future updateSubjects(String studentId) async {
    final res = await spaggiariClient.getSubjects(studentId);

    res.subjects.forEach((subject) {
      subjectDao.insertSubject(
          subjectMapper.convertSubjectEntityToInsertable(subject));
      subject.teachers.forEach((professor) {
        professorDao.insertProfessor(subjectMapper
            .convertProfessorEntityToInsertable(professor, subject.id));
      });
    });
  }
}
