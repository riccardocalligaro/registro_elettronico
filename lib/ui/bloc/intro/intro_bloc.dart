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
import 'package:registro_elettronico/domain/repository/timetable_repository.dart';
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
  TimetableRepository timetableRepository;

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
    this.timetableRepository,
  );
  @override
  IntroState get initialState => IntroInitial();

  @override
  Stream<IntroState> mapEventToState(
    IntroEvent event,
  ) async* {
    if (event is FetchAllData) {
      final start = DateTime.now();
      FLog.info(text: 'Getting all data');
      yield IntroLoading(0);
      try {
        final prefs = await SharedPreferences.getInstance();
        await absencesRepository.updateAbsences();
        prefs.setInt(PrefsConstants.LAST_UPDATE_ABSENCES,
            DateTime.now().millisecondsSinceEpoch);
        yield IntroLoading(10);

        FLog.info(text: 'Updated absences');

        await agendaRepository.updateAllAgenda();
        prefs.setInt(PrefsConstants.LAST_UPDATE_AGENDA,
            DateTime.now().millisecondsSinceEpoch);

        FLog.info(text: 'Updated agenda');

        yield IntroLoading(20);
        await lessonsRepository.updateAllLessons();
        prefs.setInt(PrefsConstants.LAST_UPDATE_LESSONS,
            DateTime.now().millisecondsSinceEpoch);

        FLog.info(text: 'Updated lessons');

        yield IntroLoading(30);
        await noticesRepository.updateNotices();
        prefs.setInt(PrefsConstants.LAST_UPDATE_NOTICEBOARD,
            DateTime.now().millisecondsSinceEpoch);

        FLog.info(text: 'Updated notices');

        yield IntroLoading(40);
        await periodsRepository.updatePeriods();

        FLog.info(text: 'Updated periods');

        yield IntroLoading(50);
        await subjectsRepository.updateSubjects();

        FLog.info(text: 'Updated subjects');

        yield IntroLoading(60);
        await gradesRepository.updateGrades();
        prefs.setInt(PrefsConstants.LAST_UPDATE_GRADES,
            DateTime.now().millisecondsSinceEpoch);

        FLog.info(text: 'Updated grades');

        yield IntroLoading(70);
        await notesRepository.updateNotes();
        prefs.setInt(PrefsConstants.LAST_UPDATE_NOTES,
            DateTime.now().millisecondsSinceEpoch);

        FLog.info(text: 'Updated notes');

        yield IntroLoading(80);
        await didacticsRepository.updateDidactics();
        prefs.setInt(PrefsConstants.LAST_UPDATE_SCHOOL_MATERIAL,
            DateTime.now().millisecondsSinceEpoch);

        FLog.info(text: 'Updated school material');

        prefs.setInt(PrefsConstants.LAST_UPDATE_HOME,
            DateTime.now().millisecondsSinceEpoch);

        yield IntroLoading(90);
        await documentsRepository.updateDocuments();

        FLog.info(text: 'Updated documents');

        final difference = start.difference(DateTime.now());
        FLog.info(text: 'Got all data in ${difference.inMilliseconds} ms');

        await timetableRepository.updateTimeTable();

        prefs.setBool(PrefsConstants.VITAL_DATA_DOWNLOADED, true);
        FLog.info(text: 'Updated timetable');

        yield IntroLoaded();
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error getting data necessary for the app',
          exception: e,
          stacktrace: s,
        );
        Crashlytics.instance.recordError(e, s);
        yield IntroError(e.toString());
      }
    } else if (event is Reset) {
      yield IntroInitial();
    }
  }
}
