import 'dart:async';
import 'package:bloc/bloc.dart';
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
        yield ProfessorsLoadSuccess(
          professors:
              professors.where((p) => p.subjectId == event.subjectId).toList(),
        );
      } catch (e) {
        yield ProfessorsLoadError();
      }
    }
  }
}
