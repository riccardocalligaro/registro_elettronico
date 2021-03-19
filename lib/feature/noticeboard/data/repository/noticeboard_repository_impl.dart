import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/noticeboard/data/datasource/noticeboard_local_datasource.dart';
import 'package:registro_elettronico/feature/noticeboard/data/datasource/noticeboard_remote_datasource.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/attachment/attachment_file.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/attachment_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/notice_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/noticeboard_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeboardRepositoryImpl implements NoticeboardRepository {
  static const String lastUpdateKey = 'noticeboardLastUpdate';

  final NoticeboardLocalDatasource noticeboardLocalDatasource;
  final NoticeboardRemoteDatasource noticeboardRemoteDatasource;

  final SharedPreferences sharedPreferences;

  NoticeboardRepositoryImpl({
    @required this.noticeboardLocalDatasource,
    @required this.noticeboardRemoteDatasource,
    @required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, Success>> updateNotices({bool ifNeeded}) async {
    try {
      if (!ifNeeded |
          (ifNeeded && needUpdate(sharedPreferences.getInt(lastUpdateKey)))) {
        final localNotices = await noticeboardLocalDatasource.getAllNotices();

        final remoteNotices =
            await noticeboardRemoteDatasource.getNoticeboard();

        List<NoticeAttachmentLocalModel> mappedRemoteAttachments = [];

        for (final notice in remoteNotices) {
          final localAttachments = notice.attachments
              .map((e) => e.toLocalModel(notice.pubId))
              .toList();
          mappedRemoteAttachments.addAll(localAttachments);
        }

        final remoteIds = remoteNotices.map((e) => e.pubId).toList();

        List<NoticeLocalModel> noticesToDelete = [];

        for (final localNotice in localNotices) {
          if (!remoteIds.contains(localNotice.pubId)) {
            noticesToDelete.add(localNotice);
          }
        }

        await noticeboardLocalDatasource.insertNotices(
          remoteNotices
              .map(
                (e) => e.toLocalModel(),
              )
              .toList(),
        );

        await noticeboardLocalDatasource.deleteAllAttachments();

        await noticeboardLocalDatasource
            .insertAttachments(mappedRemoteAttachments);

        // delete the noticeboard that were removed from the remote source
        await noticeboardLocalDatasource.deleteNotices(noticesToDelete);

        await sharedPreferences.setInt(
            lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

        return Right(SuccessWithUpdate());
      } else {
        return Right(Success());
      }
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Stream<Resource<List<NoticeDomainModel>>> watchAllNotices() {
    return Rx.combineLatest2(
      noticeboardLocalDatasource.watchAllNotices(),
      noticeboardLocalDatasource.watchAllAttachments(),
      (
        List<NoticeLocalModel> localNotices,
        List<NoticeAttachmentLocalModel> localAttachments,
      ) {
        final domainAttachments = localAttachments
            .map((l) => AttachmentDomainModel.fromLocalModel(l))
            .toList();

        final mappedAttachments = groupBy<AttachmentDomainModel, int>(
          domainAttachments,
          (e) => e.pubId,
        );

        final domainNotices = localNotices
            .map(
              (l) => NoticeDomainModel.fromLocalModel(
                l: l,
                attachments: mappedAttachments[l.pubId],
              ),
            )
            .toList();

        domainNotices.sort((b, a) => a.date.compareTo(b.date));

        return Resource.success(data: domainNotices);
      },
    ).handleError((e, s) {
      Logger.e(exception: e, stacktrace: s);
    }).onErrorReturnWith(
      (e) {
        return Resource.failed(error: handleStreamError(e));
      },
    );
  }

  @override
  Stream<Resource<GenericAttachment>> downloadFile({
    NoticeDomainModel notice,
    AttachmentDomainModel attachment,
  }) async* {
    StreamController<Resource<GenericAttachment>> resourceStreamController =
        StreamController();

    if (attachment == null) {
      try {
        resourceStreamController.add(Resource.loading(progress: 0));

        unawaited(
          _readNoticeAndGetContent(notice: notice)
              .then(
                (textContent) async {
                  resourceStreamController.add(
                    Resource.success(
                      data: AttachmentText(textContent),
                    ),
                  );
                },
              )
              .catchError(
                (e) => resourceStreamController.add(
                  Resource.failed(
                    error: handleStreamError(e),
                  ),
                ),
              )
              .whenComplete(() => resourceStreamController.close()),
        );

        yield* resourceStreamController.stream;
      } catch (e, s) {
        yield Resource.failed(error: handleStreamError(e, s));
        await resourceStreamController.close();
      }
    } else {
      try {
        resourceStreamController.add(Resource.loading(progress: 0));
        unawaited(
          _readNoticeAndGetPath(attachment: attachment, notice: notice).then(
            (filePath) {
              noticeboardRemoteDatasource
                  .downloadNotice(
                    notice: notice,
                    attachment: attachment,
                    savePath: filePath,
                    onProgress: (received, total) {
                      resourceStreamController.add(
                        Resource.loading(progress: received / total),
                      );
                    },
                  )
                  .then(
                    (_) async {
                      final localModel = notice.toLocalModel();

                      await noticeboardLocalDatasource
                          .updateNotice(localModel.copyWith(readStatus: true));

                      File file = File(filePath);
                      resourceStreamController.add(
                        Resource.success(
                          data: AttachmentFile(file),
                        ),
                      );
                    },
                  )
                  .catchError(
                    (e) => resourceStreamController.add(
                      Resource.failed(
                        error: handleStreamError(e),
                      ),
                    ),
                  )
                  .whenComplete(() => resourceStreamController.close());
            },
          ),
        );

        yield* resourceStreamController.stream;
      } catch (e, s) {
        yield Resource.failed(error: handleStreamError(e, s));
        await resourceStreamController.close();
      }
    }
  }

  Future<String> _readNoticeAndGetContent({
    @required NoticeDomainModel notice,
  }) async {
    final page =
        await noticeboardRemoteDatasource.readNotice(notice.code, notice.id);

    return page.data['item']['text'];
  }

  Future<String> _readNoticeAndGetPath({
    @required NoticeDomainModel notice,
    @required AttachmentDomainModel attachment,
  }) async {
    await noticeboardRemoteDatasource.readNotice(notice.code, notice.id);
    final directory = await getApplicationDocumentsDirectory();
    final ext = attachment.fileName.split('.').last;
    final filePath =
        '${directory.path}/${notice.contentTitle.replaceAll('/', '').replaceAll(' ', '_')}-${attachment.pubId}${attachment.attachNumber}.$ext';
    return filePath;
  }
}
