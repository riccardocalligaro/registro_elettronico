import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/feature/noticeboard/data/model/notice_remote_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/profile_utils.dart';

class NoticeMapper {
  static db.Notice convertNoticeEntityToInsertable(NoticeRemoteModel notice) {
    return db.Notice(
      pubId: notice.pubId ?? GlobalUtils.getRandomNumber(),
      pubDate: DateTime.parse(notice.pubDT) ?? DateTime.now(),
      readStatus: notice.readStatus ?? false,
      eventCode: notice.evtCode ?? "CF",
      contentId: notice.cntId ?? GlobalUtils.getRandomNumber(),
      contentValidFrom: DateUtils.getDateFromApiString(notice.cntValidFrom),
      contentValidTo: DateUtils.getDateFromApiString(notice.cntValidTo),
      contentValidInRange: notice.cntValidInRange ?? true,
      contentStatus: notice.cntStatus ?? "active",
      contentTitle: notice.cntTitle ?? "😶",
      contentCategory: notice.cntCategory ?? "😶",
      contentHasAttach: notice.cntHasAttach ?? false,
      contentHasChanged: notice.cntHasChanged ?? false,
      needJoin: notice.needJoin ?? false,
      needReply: notice.needReply ?? false,
      needFile: notice.needFile ?? false,
      //eventId: notice.eventoId ?? "${GlobalUtils.getRandomNumber()}",
    );
  }

  static db.Attachment convertAttachmentEntityToInsertable(
      int pubId, AttachmentRemoteModel attachment) {
    return db.Attachment(
      pubId: pubId ?? GlobalUtils.getRandomNumber(),
      attachNumber: attachment.attachNum ?? GlobalUtils.getRandomNumber(),
      fileName: attachment.fileName ?? ProfileUtils.createCryptoRandomString(),
    );
  }
}
