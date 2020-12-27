import 'package:dio/dio.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/didactics/data/model/didactics_remote_models.dart';

abstract class DidacticsRepository {
  // Updates didactics from spaggiari
  Future updateDidactics();

  // Read a file
  Future<List<int>> getDidacticsFile();

  // Gets all the teachers
  Future<List<DidacticsTeacher>> getTeachersGrouped();

  Future<List<DidacticsFolder>> getFolders();

  Future<List<DidacticsContent>> getContents();

  Future<DownloadAttachmentTextResponse> getTextAtachment(int fileID);

  Future<DownloadAttachmentURLResponse> getURLAtachment(int fileID);

  Future<Response> getFileAttachment(int fileID);

  Future insertDownloadedFile(DidacticsDownloadedFile downloadedFile);

  Future<DidacticsDownloadedFile> getDownloadedFileFromContentId(int contentId);

  Future deleteDownloadedFile(DidacticsDownloadedFile downloadedFile);

  Future deleteAllDidactics();
}
