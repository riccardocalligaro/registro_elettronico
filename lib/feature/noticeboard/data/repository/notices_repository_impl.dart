import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/core/network/network_info.dart';
import 'package:registro_elettronico/feature/noticeboard/data/dao/notice_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/notice_mapper.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/notices_repository.dart';

class NoticesRepositoryImpl implements NoticesRepository {
  NoticeDao noticeDao;
  ProfileDao profileDao;
  SpaggiariClient spaggiariClient;
  NetworkInfo networkInfo;
  NoticesRepositoryImpl(
    this.noticeDao,
    this.profileDao,
    this.spaggiariClient,
    this.networkInfo,
  );

  @override
  Future updateNotices() async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();
      final response = await spaggiariClient.getNoticeBoard(profile.studentId);

      List<Notice> notices = [];
      List<Attachment> attachments = [];

      response.items.forEach((notice) {
        notices.add(NoticeMapper.convertNoticeEntityToInsertable(notice));
        notice.attachments.forEach((attachment) {
          attachments.add(NoticeMapper.convertAttachmentEntityToInsertable(
              notice.pubId, attachment));
        });
      });

      FLog.info(
        text:
            'Got ${response.items.length} notice items from server, procceding to insert in database',
      );

      await noticeDao.deleteAllNotices();
      await noticeDao.deleteAllAttachments();

      noticeDao.insertNotices(notices);
      noticeDao.insertAttachments(attachments);
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
      final profile = await profileDao.getProfile();

      await spaggiariClient.readNotice(
          profile.studentId, notice.eventCode, notice.pubId.toString(), "");

      noticeDao.updateNotice(notice.copyWith(readStatus: true));
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
