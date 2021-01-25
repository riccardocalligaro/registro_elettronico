import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/content_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/downloaded_file_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/folder_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/teacher_local_model.dart';

part 'didactics_dao.g.dart';

@UseDao(tables: [
  DidacticsTeachers,
  DidacticsFolders,
  DidacticsContents,
  DidacticsDownloadedFiles
])
class DidacticsDao extends DatabaseAccessor<SRDatabase>
    with _$DidacticsDaoMixin {
  SRDatabase db;

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

  Future<void> insertTeachers(List<DidacticsTeacher> teachers) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(didacticsTeachers, teachers);
    });
  }

  Future<void> insertFolders(List<DidacticsFolder> folders) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(didacticsFolders, folders);
    });
  }

  Future insertDownloadedFile(DidacticsDownloadedFile file) =>
      into(didacticsDownloadedFiles).insertOnConflictUpdate(file);

  Future deleteDownloadedFile(DidacticsDownloadedFile file) =>
      delete(didacticsDownloadedFiles).delete(file);

  Future<DidacticsDownloadedFile> getDownloadedFile(int contentId) {
    return (select(didacticsDownloadedFiles)
          ..where((g) => g.contentId.equals(contentId)))
        .getSingle();
  }

  Future<void> insertContents(List<DidacticsContent> contents) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(didacticsContents, contents);
    });
  }

  Future<List<DidacticsTeacher>> getTeachersGrouped() {
    return customSelect(
      'SELECT * FROM didactics_teachers WHERE id IN (SELECT didactics_folders.teacher_id FROM didactics_folders GROUP BY didactics_folders.teacher_id)',
      readsFrom: {
        didacticsTeachers,
      },
    ).map((row) {
      return DidacticsTeacher.fromData(row.data, db);
    }).get();
  }
}
