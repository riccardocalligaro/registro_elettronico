import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/domain/repository/repositories_export.dart';
import './bloc.dart';

class ProfessorsBloc extends Bloc<ProfessorsEvent, ProfessorsState> {
  SubjectsRepository subjectsRepository;

  ProfessorsBloc(this.subjectsRepository);

  @override
  ProfessorsState get initialState => ProfessorsInitial();

  @override
  Stream<ProfessorsState> mapEventToState(
    ProfessorsEvent event,
  ) async* {
    if (event is GetProfessorsForSubject) {
      yield ProfessorsLoadInProgress();
      try {
        final professors = await subjectsRepository.getAllProfessors();
        FLog.info(text: 'BloC -> Got ${professors.length} professors');
        yield ProfessorsLoadSuccess(
          professors:
              professors.where((p) => p.subjectId == event.subjectId).toList(),
        );
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error getting professors for subject',
          exception: e,
          stacktrace: s,
        );
        Crashlytics.instance.recordError(e, s);
        yield ProfessorsLoadError();
      }
    }
  }
}
