import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/agenda/data/dao/agenda_dao.dart';
import 'package:registro_elettronico/feature/didactics/data/dao/didactics_dao.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/downloaded_file_local_model.dart';
import 'package:registro_elettronico/feature/scrutini/data/dao/document_dao.dart';
import 'package:registro_elettronico/feature/grades/data/dao/grade_dao.dart';
import 'package:registro_elettronico/feature/lessons/data/dao/lesson_dao.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/noticeboard/data/dao/notice_dao.dart';
import 'package:registro_elettronico/feature/periods/data/dao/period_dao.dart';
import 'package:registro_elettronico/feature/professors/data/dao/professor_dao.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/feature/subjects/data/dao/subject_dao.dart';
import 'package:registro_elettronico/feature/timetable/data/dao/timetable_dao.dart';
import 'package:registro_elettronico/feature/absences/data/model/absence_local_model.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_local_model.dart';
import 'package:registro_elettronico/feature/notes/data/model/local/attachment_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/content_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/folder_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/teacher_local_model.dart';
import 'package:registro_elettronico/feature/scrutini/data/model/document_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
import 'package:registro_elettronico/feature/lessons/data/model/lesson_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/model/local_grade_local_model.dart';
import 'package:registro_elettronico/feature/notes/data/model/local/note_local_model.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/notice_local_model.dart';
import 'package:registro_elettronico/feature/periods/data/model/period_local_model.dart';
import 'package:registro_elettronico/feature/professors/data/model/professor_table.dart';
import 'package:registro_elettronico/feature/profile/data/model/profile_local_model.dart';
import 'package:registro_elettronico/feature/subjects/data/model/subject_local_model.dart';
import 'package:registro_elettronico/feature/timetable/data/model/timetale_local_model.dart';

part 'moor_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'registro.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}

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
  NotesAttachments,
  DidacticsTeachers,
  DidacticsFolders,
  DidacticsContents,
  DidacticsDownloadedFiles,
  LocalGrades,
  TimetableEntries,
  Documents,
  SchoolReports,
  DownloadedDocuments,
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
  TimetableDao,
  DocumentsDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            await m.drop(attachments);
            await m.drop(notices);
            await m.createTable(attachments);
            await m.createTable(notices);
          }
        },
      );

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
