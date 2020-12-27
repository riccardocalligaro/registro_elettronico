import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class NoticesRepository {
  /// Updates all the notices in the database
  Future updateNotices();

  // By the default the notices are already ordered
  Future<List<Notice>> getAllNotices();

  Future<List<Attachment>> getAttachmentsForPubId(int pubId);

  Future<List<int>> downloadFile({
    @required Notice notice,
    @required int attachNumber,
  });

  Future insertNotice(Notice notice);

  Future deleteAllNotices();

  /// Based on the primary key it replaces the notice
  Future updateNotice(Notice notice);
}
