import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/domain/repository/repositories_export.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  DocumentsRepository documentsRepository;

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
    this.documentsRepository,
  );
  @override
  IntroState get initialState => IntroInitial();

  @override
  Stream<IntroState> mapEventToState(
    IntroEvent event,
  ) async* {
    if (event is FetchAllData) {
      final start = DateTime.now();
      FLog.info(text: 'Getting all data -> ${DateTime.now().toString()}');
      yield IntroLoading(0);
      try {
        final prefs = await SharedPreferences.getInstance();
        await absencesRepository.updateAbsences();
        prefs.setInt(PrefsConstants.LAST_UPDATE_ABSENCES,
            DateTime.now().millisecondsSinceEpoch);
        yield IntroLoading(10);

        await agendaRepository.updateAllAgenda();
        prefs.setInt(PrefsConstants.LAST_UPDATE_AGENDA,
            DateTime.now().millisecondsSinceEpoch);

        yield IntroLoading(20);
        await lessonsRepository.updateAllLessons();
        prefs.setInt(PrefsConstants.LAST_UPDATE_LESSONS,
            DateTime.now().millisecondsSinceEpoch);

        yield IntroLoading(30);
        await noticesRepository.updateNotices();
        prefs.setInt(PrefsConstants.LAST_UPDATE_NOTICEBOARD,
            DateTime.now().millisecondsSinceEpoch);

        yield IntroLoading(40);
        await periodsRepository.updatePeriods();

        yield IntroLoading(50);
        await subjectsRepository.updateSubjects();

        yield IntroLoading(60);
        await gradesRepository.updateGrades();
        prefs.setInt(PrefsConstants.LAST_UPDATE_GRADES,
            DateTime.now().millisecondsSinceEpoch);

        yield IntroLoading(70);
        await notesRepository.updateNotes();
        prefs.setInt(PrefsConstants.LAST_UPDATE_NOTES,
            DateTime.now().millisecondsSinceEpoch);

        yield IntroLoading(80);
        await didacticsRepository.updateDidactics();
        prefs.setInt(PrefsConstants.LAST_UPDATE_SCHOOL_MATERIAL,
            DateTime.now().millisecondsSinceEpoch);

        prefs.setInt(PrefsConstants.LAST_UPDATE_HOME,
            DateTime.now().millisecondsSinceEpoch);

        yield IntroLoading(90);
        await documentsRepository.updateDocuments();

        final difference = start.difference(DateTime.now());
        FLog.info(text: 'Got all data in ${difference.inMilliseconds} ms');
        yield IntroLoaded();
      } catch (e, s) {
        Crashlytics.instance.recordError(e, s);
        yield IntroError(e.toString());
      }
    } else if (event is Reset) {
      yield IntroInitial();
    }
  }
}
