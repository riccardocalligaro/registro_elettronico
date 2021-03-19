part of 'attachment_download_bloc.dart';

@immutable
abstract class AttachmentDownloadEvent {}

class AttachmentDownloadProgressTickedEvent extends AttachmentDownloadEvent {
  final double value;

  AttachmentDownloadProgressTickedEvent({
    @required this.value,
  });
}

class AttachmentDownloadErrorEvent extends AttachmentDownloadEvent {
  final Failure failure;

  AttachmentDownloadErrorEvent({
    @required this.failure,
  });
}

class AttachmentDownloadFinishedEvent extends AttachmentDownloadEvent {
  final GenericAttachment file;

  AttachmentDownloadFinishedEvent({
    @required this.file,
  });
}

class DownloadAttachment extends AttachmentDownloadEvent {
  final AttachmentDomainModel attachment;
  final NoticeDomainModel notice;

  DownloadAttachment({
    @required this.attachment,
    @required this.notice,
  });
}
