import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/content_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/downloaded_files.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/folder_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/teacher_local_model.dart';

part 'didactics_local_datasource.g.dart';

@UseDao(tables: [
  DidacticsTeachers,
  DidacticsFolders,
  DidacticsContents,
  DidacticsDownloadedFiles
])
class DidacticsLocalDatasource extends DatabaseAccessor<SRDatabase>
    with _$DidacticsLocalDatasourceMixin {
  SRDatabase db;

  DidacticsLocalDatasource(this.db) : super(db);

  Stream<List<TeacherLocalModel>> watchAllTeachers() =>
      select(didacticsTeachers).watch();

  Stream<List<FolderLocalModel>> watchAllFolders() =>
      select(didacticsFolders).watch();

  Stream<List<ContentLocalModel>> watchAllContents() =>
      select(didacticsContents).watch();

  Stream<List<DidacticsDownloadedFileLocalModel>> watchAllDownloadedFiles() =>
      select(didacticsDownloadedFiles).watch();

  Future<List<DidacticsDownloadedFileLocalModel>> getAllDownloadedFiles() =>
      select(didacticsDownloadedFiles).get();

  Future deleteTeachers() => delete(didacticsTeachers).go();

  Future deleteFolders() => delete(didacticsContents).go();

  Future deleteContents() => delete(didacticsFolders).go();

  Future<void> insertTeachers(List<TeacherLocalModel> teachers) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(didacticsTeachers, teachers);
    });
  }

  Future<void> insertFolders(List<FolderLocalModel> folders) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(didacticsFolders, folders);
    });
  }

  Future insertDownloadedFile(DidacticsDownloadedFileLocalModel file) =>
      into(didacticsDownloadedFiles).insertOnConflictUpdate(file);

  Future deleteDownloadedFile(DidacticsDownloadedFileLocalModel file) =>
      delete(didacticsDownloadedFiles).delete(file);

  Future<DidacticsDownloadedFileLocalModel> getDownloadedFile(int contentId) {
    return (select(didacticsDownloadedFiles)
          ..where((g) => g.contentId.equals(contentId)))
        .getSingle();
  }

  Future<void> insertUpdateData({
    required List<TeacherLocalModel> teachersList,
    required List<FolderLocalModel> foldersList,
    required List<ContentLocalModel> contentsList,
  }) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(didacticsTeachers, teachersList);
      batch.insertAllOnConflictUpdate(didacticsFolders, foldersList);
      batch.insertAllOnConflictUpdate(didacticsContents, contentsList);
    });
  }

  Future<void> insertContents(List<ContentLocalModel> contents) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(didacticsContents, contents);
    });
  }

  Future<List<TeacherLocalModel>> getTeachersGrouped() {
    return customSelect(
      'SELECT * FROM didactics_teachers WHERE id IN (SELECT didactics_folders.teacher_id FROM didactics_folders GROUP BY didactics_folders.teacher_id)',
      readsFrom: {
        didacticsTeachers,
      },
    ).map((row) {
      return TeacherLocalModel.fromData(row.data, db);
    }).get();
  }

  Future<void> deleteDownloadedFiles(
      List<DidacticsDownloadedFileLocalModel> filesToDelete) async {
    await batch((batch) {
      filesToDelete.forEach((entry) {
        batch.delete(didacticsDownloadedFiles, entry);
      });
    });
  }

  Future deleteTeacherWith(String id) {
    return (delete(didacticsTeachers)..where((t) => t.id.equals(id))).go();
  }
}
