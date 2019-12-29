import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/api_responses/didactics_response.dart';

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
}
