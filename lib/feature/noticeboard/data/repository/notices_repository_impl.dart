import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/noticeboard/data/dao/notice_dao.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/notice_mapper.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticesRepositoryImpl implements NoticesRepository {
  final NoticeDao noticeDao;
  final ProfileDao profileDao;
  final SpaggiariClient spaggiariClient;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final ProfileRepository profileRepository;

  NoticesRepositoryImpl(
    this.noticeDao,
    this.profileDao,
    this.spaggiariClient,
    this.networkInfo,
    this.sharedPreferences,
    this.profileRepository,
  );

  @override
  Future updateNotices() async {
    if (await networkInfo.isConnected) {
      final profile = await profileRepository.getProfile();
      final response = await spaggiariClient.getNoticeBoard(profile.studentId);

      List<Notice> notices = [];
      List<Attachment> attachments = [];

      response.items.forEach((notice) {
        notices.add(NoticeMapper.convertNoticeEntityToInsertable(notice));

        notice.attachments.forEach((attachment) {
          attachments.add(NoticeMapper.convertAttachmentEntityToInsertable(
            notice.pubId,
            attachment,
          ));
        });
      });

      Logger.info(
        'Got ${response.items.length} notice items from server, procceding to insert in database',
      );

      await noticeDao.deleteAllNotices();
      await noticeDao.deleteAllAttachments();

      await noticeDao.insertNotices(notices);
      await noticeDao.insertAttachments(attachments);

      await sharedPreferences.setInt(PrefsConstants.lastUpdateNoticeboard,
          DateTime.now().millisecondsSinceEpoch);
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future deleteAllNotices() {
    return noticeDao.deleteAllNotices();
  }

  @override
  Future<List<Notice>> getAllNotices() {
    return noticeDao.getAllNotices();
  }

  @override
  Future<List<Attachment>> getAttachmentsForPubId(int pubId) {
    return noticeDao.getAttachmentsForPubId(pubId);
  }

  @override
  Future insertNotice(Notice notice) {
    return noticeDao.insertNotice(notice);
  }

  @override
  Future updateNotice(Notice notice) {
    return noticeDao.updateNotice(notice);
  }

  @override
  Future<List<int>> downloadFile({
    @required Notice notice,
    @required int attachNumber,
  }) async {
    if (await networkInfo.isConnected) {
      final profile = await profileRepository.getProfile();

      await spaggiariClient.readNotice(
          profile.studentId, notice.eventCode, notice.pubId.toString(), "");

      await noticeDao.updateNotice(notice.copyWith(readStatus: true));
      final file = spaggiariClient.getNotice(
        profile.studentId,
        notice.eventCode,
        notice.pubId.toString(),
        attachNumber.toString(),
      );
      return file;
    } else {
      throw NotConntectedException();
    }
  }
}
