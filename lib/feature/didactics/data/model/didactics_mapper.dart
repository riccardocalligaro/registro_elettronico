import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/feature/didactics/data/model/didactics_remote_models.dart';

class DidacticsMapper {
  static db.DidacticsTeacher convertTeacherEntityToInsertable(TeacherRemoteModel teacher) {
    return db.DidacticsTeacher(
      id: teacher.teacherId ?? "",
      name: teacher.teacherName ?? "",
      firstName: teacher.teacherFirstName ?? "",
      lastName: teacher.teacherLastName ?? "",
    );
  }

  static db.DidacticsFolder convertFolderEntityToInsertable(
      FolderRemoteModel folder, String teacherId) {
    return db.DidacticsFolder(
      teacherId: teacherId ?? "",
      name: folder.folderName ?? "",
      lastShare: DateTime.parse(folder.lastShareDT) ?? DateTime.now(),
      id: folder.folderId ?? -1,
    );
  }

  static db.DidacticsContent convertContentEntityToInsertable(
      ContentRemoteModel content, int folderId) {
    return db.DidacticsContent(
      folderId: folderId,
      name: content.contentName,
      date: DateTime.parse(content.shareDT) ?? DateTime.now(),
      objectId: content.objectId,
      type: content.objectType,
      id: content.contentId,
    );
  }
}
