import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/attachment_local_model.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/notice_local_model.dart';

part 'notice_dao.g.dart';

@UseDao(tables: [
  Notices,
  Attachments,
])
class NoticeDao extends DatabaseAccessor<AppDatabase> with _$NoticeDaoMixin {
  AppDatabase db;

  NoticeDao(this.db) : super(db);

  Stream<List<Notice>> watchAllNotices() => select(notices).watch();

  // By the default the notices are already ordered
  Future<List<Notice>> getAllNotices() {
    return (select(notices)
          ..orderBy([
            (t) => OrderingTerm(expression: t.pubDate, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Future of all attachments
  Future<List<Attachment>> getAllAttachments() => select(attachments).get();

  Future<List<Attachment>> getAttachmentsForPubId(int pubId) =>
      (select(attachments)..where((entry) => entry.pubId.equals(pubId))).get();

  Future insertNotice(Notice notice) =>
      into(notices).insertOnConflictUpdate(notice);

  Future<void> insertNotices(List<Notice> noticesList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(notices, noticesList);
    });
  }

  Future insertAttachment(Attachment attachment) =>
      into(attachments).insertOnConflictUpdate(attachment);

  Future<void> insertAttachments(List<Attachment> attachmentsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(attachments, attachmentsList);
    });
  }

  Future deleteAllNotices() => delete(notices).go();

  Future deleteNotice(Notice notice) => delete(notices).delete(notice);

  Future deleteAllAttachments() => delete(attachments).go();

  /// Based on the primary key it replaces the notice
  Future updateNotice(Notice notice) => update(notices).replace(notice);
}
