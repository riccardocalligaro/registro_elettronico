import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/absences/data/model/absence_local_model.dart';
import 'package:registro_elettronico/feature/agenda/data/datasource/local/agenda_local_datasource.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_event_local_model.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/profile_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/data/datasource/didactics_local_datasource.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/content_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/downloaded_files.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/folder_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/teacher_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_local_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/model/local_grade_local_model.dart';
import 'package:registro_elettronico/feature/lessons/data/datasource/lessons_local_datasource.dart';
import 'package:registro_elettronico/feature/lessons/data/model/lesson_local_model.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/notes/data/model/local/note_local_model.dart';
import 'package:registro_elettronico/feature/noticeboard/data/datasource/noticeboard_local_datasource.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/attachment/attachment_local_model.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/notice/notice_local_model.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_local_datasource.dart';
import 'package:registro_elettronico/feature/periods/data/model/period_local_model.dart';
import 'package:registro_elettronico/feature/professors/data/datasource/professors_local_datasource.dart';
import 'package:registro_elettronico/feature/professors/data/model/professor_local_model.dart';
import 'package:registro_elettronico/feature/scrutini/data/dao/document_dao.dart';
import 'package:registro_elettronico/feature/scrutini/data/model/document_local_model.dart';
import 'package:registro_elettronico/feature/subjects/data/datasource/subject_local_datasource.dart';
import 'package:registro_elettronico/feature/subjects/data/model/subject_local_model.dart';
import 'package:registro_elettronico/feature/timetable/data/datasource/timetable_local_datasource.dart';
import 'package:registro_elettronico/feature/timetable/data/model/timetable_entry_local_model.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'moor_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final SharedPreferences sharedPreferences = sl();
    String dbName = sharedPreferences.getString(PrefsConstants.databaseName);

    if (dbName == null ||
        dbName == PrefsConstants.databaseNameBeforeMigration) {
      dbName = PrefsConstants.defaultDbName;
    }

    final file = File(p.join(dbFolder.path, '$dbName.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(tables: [
  Lessons,
  Subjects,
  Professors,
  Grades,
  AgendaEventsTable,
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
  AbsenceDao,
  NoteDao,
  DocumentsDao,
  GradesLocalDatasource,
  AgendaLocalDatasource,
  LessonsLocalDatasource,
  SubjectsLocalDatasource,
  ProfessorLocalDatasource,
  PeriodsLocalDatasource,
  NoticeboardLocalDatasource,
  TimetableLocalDatasource,
  DidacticsLocalDatasource,
])
class SRDatabase extends _$SRDatabase {
  SRDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            Logger.info('🗄️ [MIGRATIONS] From $from to $to');
            await m.deleteTable(attachments.actualTableName);
            await m.createTable(attachments);
          }
          if (from < 3) {
            await m.addColumn(grades, grades.hasSeenIt);
          }
          if (from < 4) {
            final sharedPreferences = await SharedPreferences.getInstance();
            final profilesLocalDatasource = ProfilesLocalDatasource(
              sharedPreferences: sharedPreferences,
            );
            final profile = sharedPreferences.getString(PrefsConstants.profile);

            if (profile != null) {
              final domainProfile = ProfileDomainModel.fromJson(profile);

              await profilesLocalDatasource
                  .insertProfile(domainProfile.toLocalModel());

              await sharedPreferences.setString(
                PrefsConstants.databaseName,
                PrefsConstants.databaseNameBeforeMigration,
              );
            } else {
              await m.deleteTable('profiles');
            }

            await m.createTable(agendaEventsTable);
            // attachments
            await m.deleteTable(attachments.actualTableName);
            await m.deleteTable(notices.actualTableName);

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
