import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/dio_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/feature/didactics/data/dao/didactics_dao.dart';
import 'package:registro_elettronico/feature/didactics/data/model/didactics_mapper.dart';
import 'package:registro_elettronico/feature/didactics/data/model/didactics_remote_models.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DidacticsRepositoryImpl implements DidacticsRepository {
  final SpaggiariClient spaggiariClient;
  final DidacticsDao didacticsDao;
  final ProfileDao profileDao;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final ProfileRepository profileRepository;

  DidacticsRepositoryImpl(
    this.spaggiariClient,
    this.didacticsDao,
    this.profileDao,
    this.networkInfo,
    this.sharedPreferences,
    this.profileRepository,
  );

  @override
  Future<List<int>> getDidacticsFile() {
    return null;
  }

  @override
  Future updateDidactics() async {
    if (await networkInfo.isConnected) {
      final profile = await profileRepository.getProfile();

      FLog.info(text: 'Updating didactics');

      final didactics = await spaggiariClient.getDidactics(profile.studentId);

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

      FLog.info(
        text:
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
      final profile = await profileRepository.getProfile();
      FLog.info(text: 'Getting attachment for $fileID!');
      final res = await _getAttachmentFile(profile.studentId, fileID);
      FLog.info(text: 'Got attachment for $fileID!');
      return res;
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future<DownloadAttachmentTextResponse> getTextAtachment(int fileID) async {
    if (await networkInfo.isConnected) {
      final profile = await profileRepository.getProfile();
      FLog.info(text: 'Getting text attachment for $fileID!');
      final res = spaggiariClient.getAttachmentText(profile.studentId, fileID);
      FLog.info(text: 'Got text attachment for $fileID!');
      return res;
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future<DownloadAttachmentURLResponse> getURLAtachment(int fileID) async {
    if (await networkInfo.isConnected) {
      final profile = await profileRepository.getProfile();
      FLog.info(text: 'Getting URL attachment for $fileID!');
      final res = spaggiariClient.getAttachmentUrl(profile.studentId, fileID);
      FLog.info(text: 'Got URL attachment for $fileID!');
      return res;
    } else {
      throw NotConntectedException();
    }
  }

  Future<Response> _getAttachmentFile(String studentId, int fileId) async {
    FLog.info(text: 'Getting attachment file for $fileId!');

    String baseUrl = 'https://web.spaggiari.eu/rest/v1';

    final _dio = DioClient(sl(), sl(), sl());
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
