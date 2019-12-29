import 'package:dio/dio.dart';
import 'package:injector/injector.dart';
import 'package:logger/logger.dart';
import 'package:registro_elettronico/data/db/dao/didactics_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/didactics_mapper.dart';
import 'package:registro_elettronico/domain/entity/api_responses/didactics_response.dart';
import 'package:registro_elettronico/domain/repository/didactics_repository.dart';

class DidacticsRepositoryImpl implements DidacticsRepository {
  SpaggiariClient spaggiariClient;
  DidacticsDao didacticsDao;
  ProfileDao profileDao;

  DidacticsRepositoryImpl(
    this.spaggiariClient,
    this.didacticsDao,
    this.profileDao,
  );
  @override
  Future<List<int>> getDidacticsFile() {
    return null;
  }

  @override
  Future updateDidactics() async {
    final profile = await profileDao.getProfile();
    final didactics = await spaggiariClient.getDidactics(profile.studentId);
    List<DidacticsTeacher> teachers = [];
    didactics.teachers.forEach((teacher) {
      List<DidacticsFolder> folders = [];
      final teacherDb =
          DidacticsMapper.convertTeacherEntityToInsertable(teacher);
      teacher.folders.forEach((folder) {
        folders.add(
          DidacticsMapper.convertFolderEntityToInsertable(folder, teacherDb.id),
        );
        List<DidacticsContent> contents = [];
        folder.contents.forEach((content) {
          contents.add(DidacticsMapper.convertContentEntityToInsertable(
              content, folder.folderId));
        });
        didacticsDao.insertContents(contents);
      });

      didacticsDao.insertFolders(folders);
      teachers.add(teacherDb);
    });

    didacticsDao.insertTeachers(teachers);
  }

  @override
  Future<List<DidacticsTeacher>> getTeachersGrouped() {
    return didacticsDao.getTeachersGrouped();
  }

  @override
  Future<List<DidacticsFolder>> getFolders() {
    return didacticsDao.getAllFolders();
  }

  @override
  Future<List<DidacticsContent>> getContents() {
    return didacticsDao.getAllContents();
  }

  @override
  Future<Response> getFileAttachment(int fileID) async {
    final profile = await profileDao.getProfile();
    Logger log = Logger();
    final res = await _getAttachmentFile(profile.studentId, fileID);
    log.i(res.headers);
    return res;
  }

  @override
  Future<DownloadAttachmentTextResponse> getTextAtachment(int fileID) async {
    final profile = await profileDao.getProfile();
    final res = spaggiariClient.getAttachmentText(profile.studentId, fileID);
    return res;
  }

  @override
  Future<DownloadAttachmentURLResponse> getURLAtachment(int fileID) async {
    final profile = await profileDao.getProfile();
    final res = spaggiariClient.getAttachmentUrl(profile.studentId, fileID);
    return res;
  }

  Future<Response> _getAttachmentFile(String studentId, int fileId) async {
    String baseUrl = 'https://web.spaggiari.eu/rest/v1';
    final _dio = DioClient(
        Injector.appInstance.getDependency(),
        Injector.appInstance.getDependency(),
        Injector.appInstance.getDependency());
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(fileId, 'fileId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    return _dio.createDio().request(
          '/students/$studentId/didactics/item/$fileId',
          queryParameters: queryParameters,
          options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl,
            responseType: ResponseType.bytes,
          ),
          data: _data,
        );

    // final value = Response<String>.fromJson(_result.data);
    // return Future.value(value);
  }

  @override
  Future<DidacticsDownloadedFile> getDownloadedFileFromContentId(
      int contentId) {
    return didacticsDao.getDownloadedFile(contentId);
  }

  @override
  Future insertDownloadedFile(DidacticsDownloadedFile downloadedFile) {
    return didacticsDao.insertDownloadedFile(downloadedFile);
  }

  @override
  Future deleteDownloadedFile(DidacticsDownloadedFile downloadedFile) {
    return didacticsDao.deleteDownloadedFile(downloadedFile);
  }
}
