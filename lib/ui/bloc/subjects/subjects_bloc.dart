import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/domain/repository/subjects_repository.dart';
import './bloc.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectDao subjectDao;
  ProfileRepository profileRepository;
  SubjectsRepository subjectsRepository;

  SubjectsBloc(
      this.subjectDao, this.profileRepository, this.subjectsRepository);

  @override
  SubjectsState get initialState => SubjectsNotLoaded();

  Stream<List<Subject>> get lessons => subjectDao.watchRelevanantSubjects();

  @override
  Stream<SubjectsState> mapEventToState(
    SubjectsEvent event,
  ) async* {
    if (event is FetchSubjects) {
      yield SubjectsLoading();
      try {
        final profile = await profileRepository.getDbProfile();
        subjectsRepository.updateSubjects(profile.studentId.toString());
        yield SubjectsLoaded();
      } on DioError catch (e) {
        yield SubjectsError(e.response.data.toString());
      } catch (e) {
        yield SubjectsError(e.toString());
      }
    }
  }
}
