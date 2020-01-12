import 'dart:async';

import 'package:bloc/bloc.dart';
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

  @override
  Stream<SubjectsState> mapEventToState(
    SubjectsEvent event,
  ) async* {
    if (event is UpdateSubjects) {
      yield* _mapUpdateSubjectsToState();
    } else if (event is GetSubjects) {
      yield* _mapGetSubjectsToState();
    } else if (event is GetSubjectsAndProfessors) {
      yield* _mapGetSubjectsAndProfessorsToState();
    } else if (event is GetProfessors) {
      yield* _mapGetProfessorsoState();
    }
  }

  Stream<SubjectsState> _mapUpdateSubjectsToState() async* {
    yield SubjectsUpdateLoadInProgress();
    try {
      await subjectsRepository.updateSubjects();
      yield SubjectsUpdateLoadSuccess();
    } catch (e) {
      yield SubjectsUpdateLoadError(error: e.toString());
    }
  }

  Stream<SubjectsState> _mapGetSubjectsToState() async* {
    yield SubjectsLoadInProgress();
    try {
      final subjects = await subjectsRepository.getAllSubjects();
      yield SubjectsLoadSuccess(subjects: subjects);
    } catch (e) {
      yield SubjectsLoadError(error: e.toString());
    }
  }

  Stream<SubjectsState> _mapGetSubjectsAndProfessorsToState() async* {
    yield SubjectsAndProfessorsLoadInProgress();
    try {
      final subjects = await subjectsRepository.getAllSubjects();
      final professors = await subjectsRepository.getAllProfessors();
      yield SubjectsAndProfessorsLoadSuccess(
        subjects: subjects,
        professors: professors,
      );
    } catch (e) {
      yield SubjectsAndProfessorsLoadError(error: e.toString());
    }
  }

  Stream<SubjectsState> _mapGetProfessorsoState() async* {
    yield ProfessorsLoadInProgress();
    try {
      final professors = await subjectsRepository.getAllProfessors();
      yield ProfessorsLoadSuccess(
        professors: professors,
      );
    } catch (e) {
      yield ProfessorsLoadError(error: e.toString());
    }
  }
}
