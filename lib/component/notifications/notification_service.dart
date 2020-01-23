import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/component/notifications/local_notification.dart';
import 'package:registro_elettronico/component/notifications/notification_message.dart';
import 'package:registro_elettronico/core/network/network_info.dart';
import 'package:registro_elettronico/data/db/dao/absence_dao.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/document_dao.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/note_dao.dart';
import 'package:registro_elettronico/data/db/dao/notice_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/absences_repository_impl.dart';
import 'package:registro_elettronico/data/repository/agenda_repository_impl.dart';
import 'package:registro_elettronico/data/repository/documents_repository_impl.dart';
import 'package:registro_elettronico/data/repository/grades_repository_impl.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/data/repository/notes_repository_impl.dart';
import 'package:registro_elettronico/data/repository/notices_repository_impl.dart';
import 'package:registro_elettronico/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class NotificationService {
  Future checkForNewContent() async {
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

    DataConnectionChecker dataConnectionChecker = DataConnectionChecker();
    NetworkInfo networkInfo = NetworkInfoImpl(dataConnectionChecker);
    final GradesRepository gradesRepository = GradesRepositoryImpl(
      gradeDao,
      spaggiariClient,
      profileDao,
      networkInfo,
    );

    FLog.info(
        text: '${DateTime.now().toString()} - checking for new contnet...');
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
    final notifyFinalGrades =
        prefs.getBool(PrefsConstants.FINAL_GRADES_NOTIFICATIONS) ?? false;
    final notifyNotices =
        prefs.getBool(PrefsConstants.NOTICES_NOTIFICATIONS) ?? false;

    // Send grades notifications
    if (notifyGrades) {
      FLog.info(text: 'Checking for new content in grades!');
      final gradesToNotify = await _getGradesToNotify(gradesRepository, prefs);
      FLog.info(text: 'Found ${gradesToNotify.length} new grades in grades!');

      if (gradesToNotify.length < 5) {
        gradesToNotify.forEach(
          (grade) => localNotification.showNotificationWithDefaultSound(
              grade.evtId,
              NotificationMessage.getGradeNotificationTitle(
                grade: grade.decimalValue,
              ),
              NotificationMessage.getGradeNotificationSubtitle(
                grade: grade,
              )),
        );
      }
    }

    // Send agenda notifications
    if (notifyAgenda) {
      FLog.info(text: 'Checking for new content in AGENDA!');
      final AgendaRepository agendaRepository = AgendaRepositoryImpl(
        spaggiariClient,
        AgendaDao(appDatabase),
        profileDao,
        networkInfo,
      );
      final eventsToNotify =
          await _getAgendaEventsToNotify(agendaRepository, prefs);
      FLog.info(text: 'Found ${eventsToNotify.length} NEW events in AGENDA!');
      if (eventsToNotify.length < 5) {
        eventsToNotify.forEach(
          (event) => localNotification.showNotificationWithDefaultSound(
            event.evtId,
            '📅 Nuovo evento',
            '${event.notes} il ${DateUtils.convertDateForDisplay(event.begin)}',
          ),
        );
      }
    }

    if (notifyAbsenes) {
      FLog.info(text: 'Checking for new content in ABSENCES!');
      final AbsencesRepository absencesRepository = AbsencesRepositoryImpl(
        spaggiariClient,
        AbsenceDao(appDatabase),
        profileDao,
        networkInfo,
      );
      final absencesToNotify =
          await _getAbsencesToNotify(absencesRepository, prefs);
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
      FLog.info(text: 'Checking for new content in NOTES!');
      final NotesRepository notesRepository = NotesRepositoryImpl(
        NoteDao(appDatabase),
        spaggiariClient,
        profileDao,
        networkInfo,
      );

      final notesToNotify = await _getNotesToNotify(notesRepository, prefs);

      if (notesToNotify.length < 5) {
        notesToNotify.forEach(
          (event) => localNotification.showNotificationWithDefaultSound(
            event.id,
            '⚠️ Nuova nota',
            '${event.author}',
          ),
        );
      }
    }

    if (notifyNotices) {
      FLog.info(text: 'Checking for new content in NOTICES!');
      final NoticeDao noticeDao = NoticeDao(appDatabase);

      final NoticesRepository noticesRepository = NoticesRepositoryImpl(
        noticeDao,
        profileDao,
        spaggiariClient,
        networkInfo,
      );

      final noticesToNotify =
          await _getNoticesToNotify(noticesRepository, prefs);
      if (noticesToNotify.length < 10) {
        noticesToNotify.forEach(
          (event) {
            localNotification.showNotificationWithDefaultSound(
              event.pubId,
              '📰 Nuova comunicazione',
              '${event.contentTitle}',
            );
          },
        );
      }
    }

    if (notifyFinalGrades) {
      FLog.info(text: 'Checking for new content in FINAL GRADES');
      final DocumentsDao documentsDao = DocumentsDao(appDatabase);
      final DocumentsRepository documentsRepository = DocumentsRepositoryImpl(
        spaggiariClient,
        profileRepository,
        documentsDao,
        networkInfo,
      );

      final documentsToNotify =
          await _getDocumentsToNotify(documentsRepository, prefs);

      FLog.info(text: 'Documents to notify: ${documentsToNotify.item1.length}');

      FLog.info(text: 'Reports to notify: ${documentsToNotify.item2.length}');

      documentsToNotify.item1.forEach(
        (report) => localNotification.showNotificationWithDefaultSound(
          GlobalUtils.getRandomNumber(),
          '📄 Nuovo documento',
          '${report.description}',
        ),
      );

      documentsToNotify.item2.forEach(
        (report) => localNotification.showNotificationWithDefaultSound(
          GlobalUtils.getRandomNumber(),
          '🗄 Nuovo file finale',
          '${report.description}',
        ),
      );
    }
  }

  // -- notices --

  Future<List<Notice>> _getNoticesToNotify(
    NoticesRepository noticesRepository,
    SharedPreferences prefs,
  ) async {
    List<Notice> noticesToNotify = [];
    final noticesBeforeFetching = await noticesRepository.getAllNotices();
    await noticesRepository.updateNotices();
    final noticesAfterFetching = await noticesRepository.getAllNotices();

    prefs.setInt(PrefsConstants.LAST_UPDATE_NOTICEBOARD,
        DateTime.now().millisecondsSinceEpoch);

    noticesAfterFetching.forEach(
      (notice) => {
        if (!noticesBeforeFetching.contains(notice)) noticesToNotify.add(notice)
      },
    );

    return noticesToNotify;
  }

  Future<List<Grade>> _getGradesToNotify(
    GradesRepository gradesRepository,
    SharedPreferences prefs,
  ) async {
    List<Grade> gradesToNotify = [];
    final gradesBeforeFetching = await gradesRepository.getAllGrades();
    await gradesRepository.updateGrades();
    final gradesAfterFetching = await gradesRepository.getAllGrades();

    prefs.setInt(PrefsConstants.LAST_UPDATE_GRADES,
        DateTime.now().millisecondsSinceEpoch);

    gradesAfterFetching.forEach(
      (grade) => {
        if (!gradesBeforeFetching.contains(grade)) gradesToNotify.add(grade)
      },
    );

    return gradesToNotify;
  }

  Future<Tuple2<List<SchoolReport>, List<Document>>> _getDocumentsToNotify(
    DocumentsRepository documentsRepository,
    SharedPreferences prefs,
  ) async {
    List<SchoolReport> reportsToNotify = [];
    List<Document> documentsToNotify = [];

    final before = await documentsRepository.getDocumentsAndSchoolReports();
    await documentsRepository.updateDocuments();
    final after = await documentsRepository.getDocumentsAndSchoolReports();

    prefs.setInt(PrefsConstants.LAST_UPDATE_SCRUTINI,
        DateTime.now().millisecondsSinceEpoch);

    after.value1.forEach((report) =>
        {if (!before.value1.contains(report)) reportsToNotify.add(report)});

    after.value2.forEach((document) => {
          if (!before.value2.contains(document)) documentsToNotify.add(document)
        });

    return Tuple2(reportsToNotify, documentsToNotify);
  }

  Future<List<AgendaEvent>> _getAgendaEventsToNotify(
    AgendaRepository agendaRepository,
    SharedPreferences prefs,
  ) async {
    List<AgendaEvent> eventsToNotify = [];
    final before = await agendaRepository.getAllEvents();
    await agendaRepository.updateAgendaStartingFromDate(DateTime.now());
    final after = await agendaRepository.getAllEvents();

    prefs.setInt(PrefsConstants.LAST_UPDATE_AGENDA,
        DateTime.now().millisecondsSinceEpoch);

    after.forEach((event) {
      if (!before.contains(event)) eventsToNotify.add(event);
    });
    return eventsToNotify;
  }

  Future<List<Absence>> _getAbsencesToNotify(
    AbsencesRepository absencesRepository,
    SharedPreferences prefs,
  ) async {
    List<Absence> absencesToNotify = [];
    final before = await absencesRepository.getAllAbsences();
    await absencesRepository.updateAbsences();
    final after = await absencesRepository.getAllAbsences();

    prefs.setInt(PrefsConstants.LAST_UPDATE_ABSENCES,
        DateTime.now().millisecondsSinceEpoch);

    after.forEach((event) {
      if (!before.contains(event)) absencesToNotify.add(event);
    });
    return absencesToNotify;
  }

  Future<List<Note>> _getNotesToNotify(
      NotesRepository notesRepository, SharedPreferences prefs) async {
    List<Note> notesToNotify = [];
    final before = await notesRepository.getAllNotes();
    await notesRepository.updateNotes();
    final after = await notesRepository.getAllNotes();

    prefs.setInt(PrefsConstants.LAST_UPDATE_NOTES,
        DateTime.now().millisecondsSinceEpoch);

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
