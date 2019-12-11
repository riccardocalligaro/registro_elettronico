import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/subjects_repository.dart';
import './bloc.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectDao subjectDao;
  ProfileDao profileDao;
  SubjectsRepository subjectsRepository;

  @override
  SubjectsState get initialState => SubjectsNotLoaded();

  Stream<List<Subject>> get lessons => subjectDao.watchAllSubjects();

  @override
  Stream<SubjectsState> mapEventToState(
    SubjectsEvent event,
  ) async* {
    if (event is FetchSubjects) {
      yield SubjectsLoading();
      final profile = await profileDao.getProfile();

      subjectsRepository.updateSubjects(profile.studentId.toString());
    }
    // todo: add fetch subjects, this will update subjects and professors
  }
}
