import 'package:dio/dio.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/sr_dio_client.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/didactics/data/dao/didactics_dao.dart';
import 'package:registro_elettronico/feature/didactics/data/model/didactics_mapper.dart';
import 'package:registro_elettronico/feature/didactics/data/model/didactics_remote_models.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DidacticsRepositoryImpl implements DidacticsRepository {
  final SpaggiariClient spaggiariClient;
  final DidacticsDao didacticsDao;
  final ProfilesLocalDatasource profilesLocalDatasource;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final AuthenticationRepository authenticationRepository;

  DidacticsRepositoryImpl(
    this.spaggiariClient,
    this.didacticsDao,
    this.profilesLocalDatasource,
    this.networkInfo,
    this.sharedPreferences,
    this.authenticationRepository,
  );

  @override
  Future<List<int>> getDidacticsFile() {
    return null;
  }

  @override
  Future updateDidactics() async {
    if (await networkInfo.isConnected) {
      final studentId = await authenticationRepository.getCurrentStudentId();

      Logger.info('Updating didactics');

      final didactics = await spaggiariClient.getDidactics(studentId);

      await deleteAllDidactics();

      List<DidacticsTeacher> teachers = [];
      didactics.teachers.forEach((teacher) {
        List<DidacticsFolder> folders = [];
        final teacherDb =
            DidacticsMapper.convertTeacherEntityToInsertable(teacher);
        teacher.folders.forEach((folder) {
          folders.add(
            DidacticsMapper.convertFolderEntityToInsertable(
                folder, teacherDb.id),
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

      Logger.info(
        'Got ${didactics.teachers} teachers events from server, procceding to insert in database',
      );

      await didacticsDao.insertTeachers(teachers);
      await sharedPreferences.setInt(PrefsConstants.lastUpdateSchoolMaterial,
          DateTime.now().millisecondsSinceEpoch);
    } else {
      throw NotConntectedException();
    }
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
    if (await networkInfo.isConnected) {
      final studentId = await authenticationRepository.getCurrentStudentId();
      Logger.info('Getting attachment for $fileID!');
      final res = await _getAttachmentFile(studentId, fileID);
      Logger.info('Got attachment for $fileID!');
      return res;
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future<DownloadAttachmentTextResponse> getTextAtachment(int fileID) async {
    if (await networkInfo.isConnected) {
      final studentId = await authenticationRepository.getCurrentStudentId();
      Logger.info('Getting text attachment for $fileID!');
      final res = spaggiariClient.getAttachmentText(studentId, fileID);
      Logger.info('Got text attachment for $fileID!');
      return res;
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future<DownloadAttachmentURLResponse> getURLAtachment(int fileID) async {
    if (await networkInfo.isConnected) {
      final studentId = await authenticationRepository.getCurrentStudentId();
      Logger.info('Getting URL attachment for $fileID!');
      final res = spaggiariClient.getAttachmentUrl(studentId, fileID);
      Logger.info('Got URL attachment for $fileID!');
      return res;
    } else {
      throw NotConntectedException();
    }
  }

  Future<Response> _getAttachmentFile(String studentId, int fileId) async {
    Logger.info('Getting attachment file for $fileId!');

    String baseUrl = 'https://web.spaggiari.eu/rest/v1';

    final _dio = SRDioClient(
      flutterSecureStorage: sl(),
      sharedPreferences: sl(),
      authenticationRepository: sl(),
    );

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

  @override
  Future deleteAllDidactics() async {
    await didacticsDao.deleteContents();
    await didacticsDao.deleteFolders();
    await didacticsDao.deleteTeachers();
  }
}
