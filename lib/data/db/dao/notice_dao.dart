import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/attachment_table.dart';
import 'package:registro_elettronico/data/db/table/notice_table.dart';

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
      into(notices).insert(notice, orReplace: true);

  Future insertAttachment(Attachment attachment) =>
      into(attachments).insert(attachment, orReplace: true);

  Future deleteAllNotices() => delete(notices).go();

  /// Based on the primary key it replaces the notice
  Future updateNotice(Notice notice) => update(notices).replace(notice);

  // Future deleteAbsence(Absence absence) => delete(absences).delete(absence);
}
