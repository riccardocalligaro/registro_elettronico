import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/agenda/presentation/bloc/agenda_bloc.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/grades/presentation/bloc/grades_bloc.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/feature/lessons/presentation/bloc/lessons_bloc.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/feature/periods/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/feature/periods/presentation/bloc/periods_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/feature/subjects/presentation/bloc/subjects_bloc.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences_constants.dart';

class UpdateUtils {
  static Future<void> checkForUpdates(BuildContext context) async {
    // first we get the
    final SharedPreferences sharedPreferences = sl();

    if (_needUpdateAllData(sharedPreferences)) {
      // update all the endpoints
      await UpdateUtils.updateAllData();

      await sharedPreferences.setInt(PrefsConstants.lastUpdateAllData,
          DateTime.now().millisecondsSinceEpoch);
    } else {
      if (_needUpdate(sharedPreferences)) {
        BlocProvider.of<LessonsBloc>(context).add(UpdateTodayLessons());
        BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
        BlocProvider.of<GradesBloc>(context).add(UpdateGrades());
        BlocProvider.of<GradesBloc>(context).add(GetGrades(limit: 3));

        await sharedPreferences.setInt(
            PrefsConstants.lastUpdate, DateTime.now().millisecondsSinceEpoch);
      }

      if (_needUpdateVitalData(sharedPreferences)) {
        BlocProvider.of<PeriodsBloc>(context).add(FetchPeriods());
        BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());

        await sharedPreferences.setInt(PrefsConstants.lastUpdateVitalData,
            DateTime.now().millisecondsSinceEpoch);
      }
    }
  }

  static bool _needUpdateAllData(SharedPreferences sharedPreferences) {
    final lastUpdate =
        sharedPreferences.getInt(PrefsConstants.lastUpdateAllData);
    return lastUpdate == null ||
        (DateTime.now().month == DateTime.september &&
            DateTime.fromMillisecondsSinceEpoch(lastUpdate)
                .isBefore(DateTime.now().subtract(Duration(days: 30)))) ||
        DateTime.fromMillisecondsSinceEpoch(lastUpdate)
            .isBefore(DateTime.now().subtract(Duration(days: 180)));
  }

  static bool _needUpdateVitalData(SharedPreferences sharedPreferences) {
    final lastUpdate =
        sharedPreferences.getInt(PrefsConstants.lastUpdateVitalData);
    return lastUpdate == null ||
        (DateTime.now().month == DateTime.september &&
            DateTime.fromMillisecondsSinceEpoch(lastUpdate)
                .isBefore(DateTime.now().subtract(Duration(days: 1)))) ||
        DateTime.fromMillisecondsSinceEpoch(lastUpdate)
            .isBefore(DateTime.now().subtract(Duration(days: 30)));
  }

  static bool _needUpdate(SharedPreferences sharedPreferences) {
    final lastUpdate = sharedPreferences.getInt(PrefsConstants.lastUpdate);
    return lastUpdate == null ||
        DateTime.fromMillisecondsSinceEpoch(lastUpdate)
            .isBefore(DateTime.now().subtract(Duration(minutes: 2)));
  }

  static Future<void> updateAllData() async {
    final AbsencesRepository absencesRepository = sl();
    final AgendaRepository agendaRepository = sl();
    final LessonsRepository lessonsRepository = sl();
    final NoticesRepository noticesRepository = sl();
    final PeriodsRepository periodsRepository = sl();
    final SubjectsRepository subjectsRepository = sl();
    final GradesRepository gradesRepository = sl();
    final NotesRepository notesRepository = sl();
    final DidacticsRepository didacticsRepository = sl();
    final DocumentsRepository documentsRepository = sl();
    final TimetableRepository timetableRepository = sl();

    // download the agenda, lessons and grades
    await Future.wait([
      agendaRepository.updateAllAgenda(),
      lessonsRepository.updateAllLessons(),
      gradesRepository.updateGrades(),
    ]);

    // upadte the essential data
    await Future.wait([
      periodsRepository.updatePeriods(),
      subjectsRepository.updateSubjects(),
    ]);

    await Future.wait([
      absencesRepository.updateAbsences(),
      noticesRepository.updateNotices(),
      notesRepository.updateNotes(),
      didacticsRepository.updateDidactics(),
      documentsRepository.updateDocuments(),
    ]);

    await timetableRepository.updateTimeTable();
  }
}
