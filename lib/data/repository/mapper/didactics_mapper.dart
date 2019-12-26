import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/didactics_response.dart';

class DidacticsMapper {
  static db.DidacticsTeacher convertTeacherEntityToInsertable(Teacher teacher) {
    return db.DidacticsTeacher(
      id: teacher.teacherId ?? "",
      name: teacher.teacherName ?? "",
      firstName: teacher.teacherFirstName ?? "",
      lastName: teacher.teacherLastName ?? "",
    );
  }

  static db.DidacticsFolder convertFolderEntityToInsertable(
      Folder folder, String teacherId) {
    return db.DidacticsFolder(
      teacherId: teacherId ?? "",
      name: folder.folderName ?? "",
      lastShare: DateTime.parse(folder.lastShareDT) ?? DateTime.now(),
      id: folder.folderId ?? -1,
    );
  }

  static db.DidacticsContent convertContentEntityToInsertable(
      Content content, int folderId) {
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
