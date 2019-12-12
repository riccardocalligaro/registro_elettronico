import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/table/agenda_event_table.dart';
import 'package:registro_elettronico/data/db/table/grade_table.dart';
import 'package:registro_elettronico/data/db/table/lesson_table.dart';
import 'package:registro_elettronico/data/db/table/professor_table.dart';
import 'package:registro_elettronico/data/db/table/profile_table.dart';
import 'package:registro_elettronico/data/db/table/subject_table.dart';

part 'moor_database.g.dart';

@UseMoor(tables: [
  Profiles,
  Lessons,
  Subjects,
  Professors,
  Grades,
  AgendaEvents
], daos: [
  ProfileDao,
  LessonDao,
  SubjectDao,
  ProfessorDao,
  GradeDao,
  AgendaDao
])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          logStatements: true,
        )));

  @override
  int get schemaVersion => 1;
}
