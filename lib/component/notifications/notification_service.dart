import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/component/notifications/local_notification.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/agenda_repository_impl.dart';
import 'package:registro_elettronico/data/repository/grades_repository_impl.dart';
import 'package:registro_elettronico/data/repository/mapper/grade_mapper.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final GradeMapper gradeMapper = GradeMapper();
    final GradesRepository gradesRepository = GradesRepositoryImpl(
        gradeDao, spaggiariClient, gradeMapper, profileDao);

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
      final gradesToNotify = await _getGradesToNotify(gradesRepository);
      gradesToNotify.forEach(
        (grade) => localNotification.showNotificationWithDefaultSound(
          grade.evtId,
          'Nuovi voto!',
          'Hai preso ${grade.decimalValue.toString()} in ${grade.subjectDesc}',
        ),
      );
    }

    // Send agenda notifications
    if (notifyAgenda) {
      final AgendaRepository agendaRepository = AgendaRepositoryImpl(
          spaggiariClient, AgendaDao(appDatabase), profileDao);
      final eventsToNotify = await _getAgendaEventsToNotify(agendaRepository);
      eventsToNotify.forEach(
        (event) => localNotification.showNotificationWithDefaultSound(
          event.evtId,
          'Nuovo evento!',
          '${event.notes} il ${DateUtils.convertDateForDisplay(event.begin)}',
        ),
      );
    }

    if (notifyAbsenes) {}

    if (notifyNotes) {}
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

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }
}
