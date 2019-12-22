import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/domain/repository/subjects_repository.dart';

import './bloc.dart';

/// Bloc for updating subjects
class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  ProfileRepository profileRepository;
  SubjectsRepository subjectsRepository;

  SubjectsBloc(
    this.profileRepository,
    this.subjectsRepository,
  );

  @override
  SubjectsState get initialState => SubjectsInitial();

  Stream<List<Subject>> get subjects =>
      subjectsRepository.watchRelevantSubjects();

  Stream<List<Professor>> get professors =>
      subjectsRepository.watchAllProfessors();

  @override
  Stream<SubjectsState> mapEventToState(
    SubjectsEvent event,
  ) async* {
    if (event is FetchSubjects) {
      yield SubjectsUpdateLoading();
      try {
        subjectsRepository.updateSubjects();
        yield SubjectsUpdateLoaded();
      } on DioError catch (e) {
        yield SubjectsUpdateError(e.response.data.toString());
      } catch (e) {
        yield SubjectsUpdateError(e.toString());
      }
    }
  }
}
