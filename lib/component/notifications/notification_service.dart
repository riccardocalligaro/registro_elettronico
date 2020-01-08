import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:registro_elettronico/component/notifications/local_notification.dart';
import 'package:registro_elettronico/component/notifications/notification_message.dart';
import 'package:registro_elettronico/data/db/dao/absence_dao.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/note_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/absences_repository_impl.dart';
import 'package:registro_elettronico/data/repository/agenda_repository_impl.dart';
import 'package:registro_elettronico/data/repository/grades_repository_impl.dart';
import 'package:registro_elettronico/data/repository/mapper/grade_mapper.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/data/repository/notes_repository_impl.dart';
import 'package:registro_elettronico/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  Future checkForNewContent() async {
    Logger log = Logger();
    final AppDatabase appDatabase = AppDatabase();
    final GradeDao gradeDao = GradeDao(appDatabase);
    final ProfileDao profileDao = ProfileDao(AppDatabase());
    final ProfileMapper profileMapper = ProfileMapper();
    final ProfileRepository profileRepository =
        ProfileRepositoryImpl(profileDao, profileMapper);
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final DioClient dioClient =
        DioClient(ProfileMapper(), profileRepository, flutterSecureStorage);
    final SpaggiariClient spaggiariClient =
        SpaggiariClient(dioClient.createDio());
    final GradeMapper gradeMapper = GradeMapper();
    final GradesRepository gradesRepository = GradesRepositoryImpl(
        gradeDao, spaggiariClient, gradeMapper, profileDao);

    log.i("Checking for new contnet...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final LocalNotification localNotification =
        LocalNotification(onSelectNotification);

    // We get the shared preferences and we check what to notify
    final notifyGrades =
        prefs.getBool(PrefsConstants.GRADES_NOTIFICATIONS) ?? false;
    final notifyAgenda =
        prefs.getBool(PrefsConstants.AGENDA_NOTIFICATIONS) ?? false;
    final notifyAbsenes =
        prefs.getBool(PrefsConstants.AGENDA_NOTIFICATIONS) ?? false;
    final notifyNotes =
        prefs.getBool(PrefsConstants.NOTES_NOTIFICATIONS) ?? false;

    // Send grades notifications
    if (notifyGrades) {
      log.i("Checking for new content in GRADES!");
      final gradesToNotify = await _getGradesToNotify(gradesRepository);
      log.i("Found ${gradesToNotify.length} NEW grades in GRADES!");

      if (gradesToNotify.length < 5) {
        gradesToNotify.forEach(
          (grade) => localNotification.showNotificationWithDefaultSound(
              grade.evtId,
              NotificationMessage.getGradeNotificationTitle(
                grade: grade.decimalValue,
              ),
              NotificationMessage.getGradeNotificationSubtitle(grade: grade)),
        );
      }
    }

    // Send agenda notifications
    if (notifyAgenda) {
      log.i("Checking for new content in AGENDA!");
      final AgendaRepository agendaRepository = AgendaRepositoryImpl(
          spaggiariClient, AgendaDao(appDatabase), profileDao);
      final eventsToNotify = await _getAgendaEventsToNotify(agendaRepository);
      log.i("Found ${eventsToNotify.length} NEW events in AGENDA!");
      if (eventsToNotify.length < 5) {
        eventsToNotify.forEach(
          (event) => localNotification.showNotificationWithDefaultSound(
            event.evtId,
            '📅 Nuovo evento!',
            '${event.notes} il ${DateUtils.convertDateForDisplay(event.begin)}',
          ),
        );
      }
    }

    if (notifyAbsenes) {
      log.i("Checking for new content in ABSENCES!");
      final AbsencesRepository absencesRepository = AbsencesRepositoryImpl(
          spaggiariClient, AbsenceDao(appDatabase), profileDao);
      final absencesToNotify = await _getAbsencesToNotify(absencesRepository);
      if (absencesToNotify.length < 5) {
        absencesToNotify.forEach(
          (event) => localNotification.showNotificationWithDefaultSound(
            event.evtId,
            NotificationMessage.getAbsenceNotificationTitle(event.evtCode),
            NotificationMessage.getAbsenceNotificationSubtitle(event),
          ),
        );
      }
    }

    if (notifyNotes) {
      log.i("Checking for new content in NOTES!");
      final NotesRepository notesRepository = NotesRepositoryImpl(
          NoteDao(appDatabase), spaggiariClient, profileDao);

      final notesToNotify = await _getNotesToNotify(notesRepository);

      if (notesToNotify.length < 5) {
        notesToNotify.forEach(
          (event) => localNotification.showNotificationWithDefaultSound(
            event.id,
            '⚠️ Nuova nota!',
            '${event.author}',
          ),
        );
      }
    }
  }

  Future<List<Grade>> _getGradesToNotify(
      GradesRepository gradesRepository) async {
    List<Grade> gradesToNotify = [];
    final gradesBeforeFetching = await gradesRepository.getAllGrades();
    await gradesRepository.updateGrades();
    final gradesAfterFetching = await gradesRepository.getAllGrades();

    gradesAfterFetching.forEach(
      (grade) => {
        if (!gradesBeforeFetching.contains(grade)) gradesToNotify.add(grade)
      },
    );

    return gradesToNotify;
  }

  Future<List<AgendaEvent>> _getAgendaEventsToNotify(
      AgendaRepository agendaRepository) async {
    List<AgendaEvent> eventsToNotify = [];
    final before = await agendaRepository.getAllEvents();
    await agendaRepository.updateAgendaStartingFromDate(DateTime.now());
    final after = await agendaRepository.getAllEvents();

    after.forEach((event) {
      if (!before.contains(event)) eventsToNotify.add(event);
    });
    return eventsToNotify;
  }

  Future<List<Absence>> _getAbsencesToNotify(
      AbsencesRepository absencesRepository) async {
    List<Absence> absencesToNotify = [];
    final before = await absencesRepository.getAllAbsences();
    await absencesRepository.updateAbsences();
    final after = await absencesRepository.getAllAbsences();

    after.forEach((event) {
      if (!before.contains(event)) absencesToNotify.add(event);
    });
    return absencesToNotify;
  }

  Future<List<Note>> _getNotesToNotify(NotesRepository notesRepository) async {
    List<Note> notesToNotify = [];
    final before = await notesRepository.getAllNotes();
    await notesRepository.updateNotes();
    final after = await notesRepository.getAllNotes();

    after.forEach((event) {
      if (!before.contains(event)) notesToNotify.add(event);
    });
    return notesToNotify;
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }
}
