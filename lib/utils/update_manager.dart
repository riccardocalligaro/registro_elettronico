import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/noticeboard_repository.dart';
import 'package:registro_elettronico/feature/periods/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences_constants.dart';

/// Class that manages all the updates
class SRUpdateManager {
  final SharedPreferences sharedPreferences;
  final AbsencesRepository absencesRepository;
  final AgendaRepository agendaRepository;
  final DidacticsRepository didacticsRepository;
  final GradesRepository gradesRepository;
  final LessonsRepository lessonsRepository;
  final NoticeboardRepository noticesRepository;
  final PeriodsRepository periodsRepository;
  final SubjectsRepository subjectsRepository;
  final DocumentsRepository documentsRepository;
  final NotesRepository notesRepository;
  final TimetableRepository timetableRepository;

  SRUpdateManager({
    @required this.sharedPreferences,
    @required this.absencesRepository,
    @required this.agendaRepository,
    @required this.didacticsRepository,
    @required this.gradesRepository,
    @required this.lessonsRepository,
    @required this.noticesRepository,
    @required this.periodsRepository,
    @required this.subjectsRepository,
    @required this.documentsRepository,
    @required this.notesRepository,
    @required this.timetableRepository,
  });

  Future<void> checkForUpdates() async {
    // first we get the

    final String databaseName =
        sharedPreferences.getString(PrefsConstants.databaseName);

    Logger.info('🔄 [UpdateMANAGER] Checking for db: $databaseName');

    // download di tutti i dati, partenza da 0
    if (_needToUpdateAllData(databaseName: databaseName)) {
      Logger.info('🔄 [UpdateMANAGER]: Update all data');

      // update all the endpoints
      await updateAllData(databaseName);
    } else {
      // se mancano dei dati essenziali
      final needToUpdateVitalData = await _needUpdateVitalData(
        databaseName: databaseName,
      );

      if (needToUpdateVitalData) {
        Logger.info('🔄 [UpdateMANAGER] Update vital data');

        await sharedPreferences.setInt(PrefsConstants.lastUpdateVitalData,
            DateTime.now().millisecondsSinceEpoch);

        final PeriodsRepository periodsRepository = sl();
        await periodsRepository.updatePeriods(ifNeeded: false);

        final SubjectsRepository subjectsRepository = sl();
        await subjectsRepository.updateSubjects(ifNeeded: false);
      }

      Logger.info('🔄 [UpdateMANAGER] Updating home screen data');

      // update all the basic data
      await Future.wait([
        gradesRepository.updateGrades(ifNeeded: false),
        agendaRepository.updateAllAgenda(ifNeeded: false),
        lessonsRepository.updateAllLessons(ifNeeded: false),
      ]);
    }
  }

  Future<void> updateVitalData() async {
    return Future.wait([
      periodsRepository.updatePeriods(ifNeeded: false),
      subjectsRepository.updateSubjects(ifNeeded: false),
    ]);
  }

  Future<void> updateAllData(
    String databaseName,
  ) async {
    await Future.wait([
      periodsRepository.updatePeriods(ifNeeded: false),
      subjectsRepository.updateSubjects(ifNeeded: false),
    ]);

    await sharedPreferences.setInt(
      _getAccountBasedPreferenceName(
        name: PrefsConstants.lastUpdateAllData,
        databaseName: databaseName,
      ),
      DateTime.now().millisecondsSinceEpoch,
    );

    await sharedPreferences.setInt(
      _getAccountBasedPreferenceName(
        name: PrefsConstants.lastUpdateVitalData,
        databaseName: databaseName,
      ),
      DateTime.now().millisecondsSinceEpoch,
    );
    return Future.wait([
      agendaRepository.updateAllAgenda(ifNeeded: false),
      lessonsRepository.updateAllLessons(ifNeeded: false),
      gradesRepository.updateGrades(ifNeeded: false),
      absencesRepository.updateAbsences(),
      noticesRepository.updateNotices(ifNeeded: false),
      notesRepository.updateNotes(),
      didacticsRepository.updateDidactics(),
      documentsRepository.updateDocuments(),
      timetableRepository.regenerateTimetable()
    ]);
  }

  bool _needToUpdateAllData({
    @required String databaseName,
  }) {
    final lastUpdate = sharedPreferences.getInt(
      _getAccountBasedPreferenceName(
        name: PrefsConstants.lastUpdateAllData,
        databaseName: databaseName,
      ),
    );

    final now = DateTime.now();

    final fiftyDaysAgo = now.subtract(Duration(days: 50));
    final hundredEightyDaysAgo = now.subtract(Duration(days: 180));

    final date = _date(lastUpdate);
    // questo significa che non ha mai aggiornato i dati vitali, quindi è la prima volta che usa l'app.
    if (lastUpdate == null) {
      return true;
      // se sono passati 15 giorni ed è settembre
    } else if (date.isBefore(fiftyDaysAgo) && _isSemptember(now)) {
      return true;
    } else if (date.isBefore(hundredEightyDaysAgo)) {
      return true;
    }

    return false;
  }

  Future<bool> _needUpdateVitalData({
    @required String databaseName,
  }) async {
    final lastUpdate = sharedPreferences.getInt(
      _getAccountBasedPreferenceName(
        name: PrefsConstants.lastUpdateVitalData,
        databaseName: databaseName,
      ),
    );

    // non dovrebbe succedere mai, ma mettiamolo nel caso
    if (lastUpdate == null) {
      return true;
    }

    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 15));

    if (_date(lastUpdate).isBefore(thirtyDaysAgo)) {
      return true;
    } else {
      // controlliamo e i periodi sono vuoti o è presente una data vecchia
      final needToUpdatePeriods = await periodsRepository.needToUpdatePeriods();

      final needToUpdateResponse = needToUpdatePeriods.fold(
        (failure) => false,
        (r) => r,
      );

      if (needToUpdateResponse) {
        return true;
      }

      final _needToUpdateSubjects =
          await subjectsRepository.needToUpdateSubjects();
      final needToUpdateSubjects = _needToUpdateSubjects.fold(
        (failure) => false,
        (r) => r,
      );

      if (needToUpdateSubjects) {
        return false;
      }
    }

    return false;
  }

  bool _isSemptember(
    DateTime date,
  ) {
    return date.month == DateTime.september;
  }

  DateTime _date(
    int milliseconds,
  ) {
    if (milliseconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  String _getAccountBasedPreferenceName({
    @required String name,
    @required String databaseName,
  }) {
    if (databaseName == PrefsConstants.databaseNameBeforeMigration) {
      return name;
    } else {
      return '$name$databaseName';
    }
  }
}
