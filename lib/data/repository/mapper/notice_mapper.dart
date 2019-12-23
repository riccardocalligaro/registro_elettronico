import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/noticeboard_response.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/profile_utils.dart';

class NoticeMapper {
  db.Notice convertNoticeEntityToInsertable(Items notice) {
    return db.Notice(
      pubId: notice.pubId ?? GlobalUtils.getRandomNumber(),
      pubDate: DateTime.parse(notice.pubDT) ?? DateTime.now(),
      readStatus: notice.readStatus ?? false,
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
      eventId: notice.eventoId ?? "${GlobalUtils.getRandomNumber()}",
    );
  }

  db.Attachment convertAttachmentEntityToInsertable(
      int pubId, Attachments attachment) {
    return db.Attachment(
      pubId: pubId ?? GlobalUtils.getRandomNumber(),
      attachNumber: attachment.attachNum ?? GlobalUtils.getRandomNumber(),
      fileName: attachment.fileName ?? ProfileUtils.createCryptoRandomString(),
    );
  }
}
