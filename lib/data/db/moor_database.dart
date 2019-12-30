import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/dao/absence_dao.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/didactics_dao.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/note_dao.dart';
import 'package:registro_elettronico/data/db/dao/notice_dao.dart';
import 'package:registro_elettronico/data/db/dao/period_dao.dart';
import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/dao/timetable_dao.dart';
import 'package:registro_elettronico/data/db/table/absence_table.dart';
import 'package:registro_elettronico/data/db/table/agenda_event_table.dart';
import 'package:registro_elettronico/data/db/table/attachment_table.dart';
import 'package:registro_elettronico/data/db/table/didactics/content_table.dart';
import 'package:registro_elettronico/data/db/table/didactics/downloaded_files.dart';
import 'package:registro_elettronico/data/db/table/didactics/folder_table.dart';
import 'package:registro_elettronico/data/db/table/didactics/teacher_table.dart';
import 'package:registro_elettronico/data/db/table/grade_table.dart';
import 'package:registro_elettronico/data/db/table/lesson_table.dart';
import 'package:registro_elettronico/data/db/table/local_grade_table.dart';
import 'package:registro_elettronico/data/db/table/note_table.dart';
import 'package:registro_elettronico/data/db/table/notice_table.dart';
import 'package:registro_elettronico/data/db/table/period_table.dart';
import 'package:registro_elettronico/data/db/table/professor_table.dart';
import 'package:registro_elettronico/data/db/table/profile_table.dart';
import 'package:registro_elettronico/data/db/table/subject_table.dart';
import 'package:registro_elettronico/data/db/table/timetable_table.dart';

part 'moor_database.g.dart';

@UseMoor(tables: [
  Profiles,
  Lessons,
  Subjects,
  Professors,
  Grades,
  AgendaEvents,
  Absences,
  Periods,
  Notices,
  Attachments,
  Notes,
  DidacticsTeachers,
  DidacticsFolders,
  DidacticsContents,
  DidacticsDownloadedFiles,
  LocalGrades,
  TimetableEntries
], daos: [
  ProfileDao,
  LessonDao,
  SubjectDao,
  ProfessorDao,
  GradeDao,
  AgendaDao,
  AbsenceDao,
  PeriodDao,
  NoticeDao,
  NoteDao,
  DidacticsDao,
  TimetableDao
])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          (FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite',
            logStatements: true,
          )),
        );

  @override
  int get schemaVersion => 1;

  /// Deletes all the tables from the db except the profiles, so the user is not logged out
  Future resetDbWithoutProfile() async {
    for (var table in allTables) {
      if (table.actualTableName != "profiles") {
        await delete(table).go();
      }
    }
  }

  /// This deletes [everything] from the database, the next time the user logs
  /// log in is [required]
  Future resetDb() async {
    for (var table in allTables) {
      await delete(table).go();
    }
  }
}
