import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/domain/repository/repositories_export.dart';
import './bloc.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  AbsencesRepository absencesRepository;
  AgendaRepository agendaRepository;
  LessonsRepository lessonsRepository;
  NoticesRepository noticesRepository;
  PeriodsRepository periodsRepository;
  SubjectsRepository subjectsRepository;
  GradesRepository gradesRepository;
  NotesRepository notesRepository;
  DidacticsRepository didacticsRepository;

  IntroBloc(
    this.absencesRepository,
    this.agendaRepository,
    this.lessonsRepository,
    this.notesRepository,
    this.periodsRepository,
    this.subjectsRepository,
    this.gradesRepository,
    this.noticesRepository,
    this.didacticsRepository,
  );
  @override
  IntroState get initialState => IntroInitial();

  @override
  Stream<IntroState> mapEventToState(
    IntroEvent event,
  ) async* {
    if (event is FetchAllData) {
      yield IntroLoading(0);
      try {
        await absencesRepository.updateAbsences();
        yield IntroLoading(10);
        await agendaRepository.updateAllAgenda();
        yield IntroLoading(20);
        await lessonsRepository.updateAllLessons();
        yield IntroLoading(30);
        await noticesRepository.updateNotices();
        yield IntroLoading(40);
        await periodsRepository.updatePeriods();
        yield IntroLoading(50);
        await subjectsRepository.updateSubjects();
        yield IntroLoading(60);
        await gradesRepository.updateGrades();
        yield IntroLoading(70);
        await notesRepository.updateNotes();
        yield IntroLoading(80);
        await didacticsRepository.updateDidactics();
        yield IntroLoaded();
      } catch (e) {
        yield IntroError(e.toString());
      }
    } else if (event is Reset) {
      yield IntroInitial();
    }
  }
}
