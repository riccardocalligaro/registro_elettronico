import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/attachment/attachment_local_model.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/notice/notice_local_model.dart';

part 'noticeboard_local_datasource.g.dart';

@UseDao(tables: [
  Notices,
  Attachments,
])
class NoticeboardLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$NoticeboardLocalDatasourceMixin {
  AppDatabase db;

  NoticeboardLocalDatasource(this.db) : super(db);

  Stream<List<NoticeLocalModel>> watchAllNotices() => select(notices).watch();

  Stream<List<NoticeAttachmentLocalModel>> watchAllAttachments() =>
      select(attachments).watch();

  Future<List<NoticeLocalModel>> getAllNotices() => select(notices).get();

  Future<List<NoticeAttachmentLocalModel>> getAllAttachments() =>
      select(attachments).get();

  Future<void> insertNotices(List<NoticeLocalModel> noticesList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(notices, noticesList);
    });
  }

  Future<void> insertAttachments(
      List<NoticeAttachmentLocalModel> attachmentsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(attachments, attachmentsList);
    });
  }

  Future<void> deleteNotices(List<NoticeLocalModel> noticesList) async {
    await batch((batch) {
      noticesList.forEach((entry) {
        batch.delete(notices, entry);
      });
    });
  }

  Future<void> deleteAttachments(
      List<NoticeAttachmentLocalModel> attachmentsList) async {
    await batch((batch) {
      attachmentsList.forEach((entry) {
        batch.delete(attachments, entry);
      });
    });
  }

  Future<void> deleteAllNotices() => delete(notices).go();

  Future<void> deleteAllAttachments() => delete(attachments).go();

  Future updateNotice(NoticeLocalModel notice) =>
      update(notices).replace(notice);
}
