import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';

part 'subjects_event.dart';

part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  final ProfileRepository profileRepository;
  final SubjectsRepository subjectsRepository;

  SubjectsBloc({
    @required this.profileRepository,
    @required this.subjectsRepository,
  }) : super(SubjectsInitial());

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
      await FirebaseCrashlytics.instance.recordError(e, s);
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
      await FirebaseCrashlytics.instance.recordError(e, s);
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
      await FirebaseCrashlytics.instance.recordError(e, s);
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
      await FirebaseCrashlytics.instance.recordError(e, s);
      yield ProfessorsLoadError(error: e.toString());
    }
  }
}
