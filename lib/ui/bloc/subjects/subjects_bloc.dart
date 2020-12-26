import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error updating subjects',
        exception: e,
        stacktrace: s,
      );
      FirebaseCrashlytics.instance.recordError(e, s);
      yield SubjectsUpdateLoadError(error: e.toString());
    }
  }

  Stream<SubjectsState> _mapGetSubjectsToState() async* {
    yield SubjectsLoadInProgress();
    try {
      final subjects = await subjectsRepository.getAllSubjects();
      FLog.info(text: 'BloC -> Got ${subjects.length} subjects');
      yield SubjectsLoadSuccess(subjects: subjects);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error getting all subjects',
        exception: e,
        stacktrace: s,
      );
      FirebaseCrashlytics.instance.recordError(e, s);
      yield SubjectsLoadError(error: e.toString());
    }
  }

  Stream<SubjectsState> _mapGetSubjectsAndProfessorsToState() async* {
    yield SubjectsAndProfessorsLoadInProgress();
    try {
      final subjects = await subjectsRepository.getAllSubjects();
      final professors = await subjectsRepository.getAllProfessors();
      FLog.info(text: 'BloC -> Got ${subjects.length} subjects');
      FLog.info(text: 'BloC -> Got ${professors.length} professors');

      yield SubjectsAndProfessorsLoadSuccess(
        subjects: subjects,
        professors: professors,
      );
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error getting subjects and professors',
        exception: e,
        stacktrace: s,
      );
      FirebaseCrashlytics.instance.recordError(e, s);
      yield SubjectsAndProfessorsLoadError(error: e.toString());
    }
  }

  Stream<SubjectsState> _mapGetProfessorsoState() async* {
    yield ProfessorsLoadInProgress();
    try {
      final professors = await subjectsRepository.getAllProfessors();
      FLog.info(text: 'BloC -> Got ${professors.length} professors');

      yield ProfessorsLoadSuccess(
        professors: professors,
      );
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error getting professors',
        exception: e,
        stacktrace: s,
      );
      FirebaseCrashlytics.instance.recordError(e, s);
      yield ProfessorsLoadError(error: e.toString());
    }
  }
}
