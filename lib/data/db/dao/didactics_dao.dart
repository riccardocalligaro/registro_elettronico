import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/didactics/content_table.dart';
import 'package:registro_elettronico/data/db/table/didactics/downloaded_files.dart';
import 'package:registro_elettronico/data/db/table/didactics/folder_table.dart';
import 'package:registro_elettronico/data/db/table/didactics/teacher_table.dart';

part 'didactics_dao.g.dart';

@UseDao(tables: [
  DidacticsTeachers,
  DidacticsFolders,
  DidacticsContents,
  DidacticsDownloadedFiles
])
class DidacticsDao extends DatabaseAccessor<AppDatabase>
    with _$DidacticsDaoMixin {
  AppDatabase db;
  DidacticsDao(this.db) : super(db);

  Future<List<DidacticsTeacher>> getAllTeachers() =>
      select(didacticsTeachers).get();

  Future<List<DidacticsFolder>> getAllFolders() =>
      select(didacticsFolders).get();

  Future<List<DidacticsContent>> getAllContents() =>
      select(didacticsContents).get();

  Future deleteTeachers() => delete(didacticsTeachers).go();

  Future deleteFolders() => delete(didacticsContents).go();

  Future deleteContents() => delete(didacticsFolders).go();

  Future insertTeachers(List<DidacticsTeacher> teachers) =>
      into(didacticsTeachers).insertAll(teachers, orReplace: true);

  Future insertFolders(List<DidacticsFolder> folders) =>
      into(didacticsFolders).insertAll(folders, orReplace: true);

  Future insertDownloadedFile(DidacticsDownloadedFile file) =>
      into(didacticsDownloadedFiles).insert(file, orReplace: true);

  Future deleteDownloadedFile(DidacticsDownloadedFile file) =>
      delete(didacticsDownloadedFiles).delete(file);

  Future<DidacticsDownloadedFile> getDownloadedFile(int contentId) {
    return (select(didacticsDownloadedFiles)
          ..where((g) => g.contentId.equals(contentId)))
        .getSingle();
  }

  Future insertContents(List<DidacticsContent> contents) => into(
        didacticsContents,
      ).insertAll(contents, orReplace: true);
// "SELECT * FROM TEACHER WHERE ID IN (SELECT FOLDER.TEACHER FROM FOLDER WHERE PROFILE=:profile GROUP BY FOLDER.TEACHER)"
  Future<List<DidacticsTeacher>> getTeachersGrouped() {
    return customSelectQuery(
      'SELECT * FROM didactics_teachers WHERE id IN (SELECT didactics_folders.teacher_id FROM didactics_folders GROUP BY didactics_folders.teacher_id)',
      readsFrom: {
        didacticsTeachers,
      },
    ).map((row) {
      return DidacticsTeacher.fromData(row.data, db);
    }).get();
  }

  // Future deleteAllDidactics() {
  //   return customSelectQuery(
  //     'DELETE * FROM didactics_teachers',
  //     readsFrom: {
  //       didacticsTeachers,
  //       didacticsFolders,
  //       didacticsContents,
  //       didacticsDownloadedFiles
  //     }
  //   ).get();
  // }
}
