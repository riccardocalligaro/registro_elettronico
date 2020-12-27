import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/feature/periods/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';

class UpdateUtils {
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
