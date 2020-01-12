import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/data/db/dao/notice_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/notice_mapper.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';

class NoticesRepositoryImpl implements NoticesRepository {
  NoticeDao noticeDao;
  ProfileDao profileDao;
  NoticeMapper noticeMapper;
  SpaggiariClient spaggiariClient;

  NoticesRepositoryImpl(
      this.noticeDao, this.profileDao, this.spaggiariClient, this.noticeMapper);

  @override
  Future updateNotices() async {
    final profile = await profileDao.getProfile();
    final response = await spaggiariClient.getNoticeBoard(profile.studentId);

    await noticeDao.deleteAllNotices();
    await noticeDao.deleteAllAttachments();

    List<Notice> notices = [];
    List<Attachment> attachments = [];

    response.items.forEach((notice) {
      notices.add(noticeMapper.convertNoticeEntityToInsertable(notice));
      notice.attachments.forEach((attachment) {
        attachments.add(noticeMapper.convertAttachmentEntityToInsertable(
            notice.pubId, attachment));
      });
    });

    noticeDao.insertNotices(notices);
    noticeDao.insertAttachments(attachments);
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
  }
}
