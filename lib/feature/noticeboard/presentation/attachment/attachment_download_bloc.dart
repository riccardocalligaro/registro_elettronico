import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/attachment/attachment_file.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/attachment_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/notice_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/noticeboard_repository.dart';

part 'attachment_download_event.dart';
part 'attachment_download_state.dart';

class AttachmentDownloadBloc
    extends Bloc<AttachmentDownloadEvent, AttachmentDownloadState> {
  final NoticeboardRepository noticeboardRepository;

  StreamSubscription _downloadSubscription;

  AttachmentDownloadBloc({
    @required this.noticeboardRepository,
  }) : super(AttachmentDownloadInitial());

  @override
  Stream<AttachmentDownloadState> mapEventToState(
    AttachmentDownloadEvent event,
  ) async* {
    if (event is AttachmentDownloadErrorEvent) {
      yield AttachmentDownloadFailure(failure: event.failure);
    } else if (event is AttachmentDownloadFinishedEvent) {
      yield AttachmentDownloadSuccess(downloadedAttachment: event.file);
    } else if (event is AttachmentDownloadProgressTickedEvent) {
      yield AttachmentDownloadInProgress(percentage: event.value);
    } else if (event is DownloadAttachment) {
      _downloadSubscription = noticeboardRepository
          .downloadFile(notice: event.notice, attachment: event.attachment)
          .listen(
        (resource) {
          if (resource.status == Status.failed) {
            add(AttachmentDownloadErrorEvent(failure: resource.failure));
          } else if (resource.status == Status.success) {
            add(AttachmentDownloadFinishedEvent(file: resource.data));
          } else if (resource.status == Status.loading) {
            add(
              AttachmentDownloadProgressTickedEvent(value: resource.progress),
            );
          }
        },
      );
    }
  }

  @override
  Future<void> close() {
    _downloadSubscription.cancel();
    return super.close();
  }
}
